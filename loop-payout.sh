while true
do

cool=($PROVIDER)

home=$(pwd)

for i in "${cool[@]}"; do

export AKASH_ACCOUNT_ADDRESS=$i
export AKASH_OUTPUT=json
export PROVIDER=$i

if ! command -v dig &> /dev/null
then
    echo "dig could not be found"
    apt-get install -y dnsutils
fi


if ! command -v column &> /dev/null
then
    echo "column could not be found"
    apt-get install -y bsdmainutils
fi

if ! command -v jq &> /dev/null
then
    echo "jq could not be found"
    apt-get install -y jq
fi

if ! command -v bc &> /dev/null
then
    echo "bc could not be found"
    apt-get install -y bc
fi

if ! command -v akash &> /dev/null
then
    echo "akash could not be found"
    exit
fi

HEIGHT=$(akash query block --node $NODE | jq -r '.block.header.height')
akash query market lease list --node $NODE \
  --provider $PROVIDER \
  --gseq 0 --oseq 0 \
  --state active --page 1 --limit 5000 \
  | jq -r '.leases[].lease | [(.lease_id | .owner, (.dseq|tonumber), (.gseq|tonumber), (.oseq|tonumber), .provider)] | @tsv | gsub("\\t";",")' \
    | while IFS=, read owner dseq gseq oseq provider; do \
      REMAINING=$(akash query escrow blocks-remaining --dseq $dseq --owner $owner --node $NODE | jq -r '.balance_remaining')
      ## FOR DEBUGGING/INFORMATIONAL PURPOSES
      echo "INFO: $owner/$dseq/$gseq/$oseq balance remaining $REMAINING"


if [[ $ONLY_NEGATIVE_BALANCES == "true" ]]; then

      if (( $(echo "$REMAINING < 0" | bc -l &> /dev/null) )); then

        ( sleep 2s; cat key-pass.txt; cat key-pass.txt ) | akash tx market lease withdraw --node $NODE --provider $PROVIDER --owner $owner --dseq $dseq --oseq $oseq --gseq $gseq --fees="${FEE}"uakt --gas=auto --gas-adjustment=1.1 -y --from $PROVIDER -b $MODE

        sleep $DELAY

	fi
else

        ( sleep 2s; cat key-pass.txt; cat key-pass.txt ) | akash tx market lease withdraw --node $NODE --provider $PROVIDER --owner $owner --dseq $dseq --oseq $oseq --gseq $gseq --fees="${FEE}"uakt --gas=auto --gas-adjustment=1.1 -y --from $PROVIDER -b $MODE
	sleep $DELAY

fi


done

echo "Waiting $DELAY seconds before next loop"
sleep $DELAY

done

done

