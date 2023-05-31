export AKASH_CHAIN_ID=akashnet-2
export AKASH_NODE=$NODE
export AKASH_KEYRING_BACKEND=os
export AKASH_VERSION=0.22.6
export AKASH_NET=https://raw.githubusercontent.com/ovrclk/net/master/mainnet
export AKASH_KEY_NAME=default
export AKASH_SECRET=$PASS

export AKASH_ACCOUNT_ADDRESS=$(akash query provider list -o json --limit 10000 --node $NODE | jq -r '.providers[] | select(.host_uri | contains("'"$PROVIDER"'")) | .owner')
echo "Found Akash provider address $PROVIDER"
export PROVIDER=$AKASH_ACCOUNT_ADDRESS
pwd
echo "Adding password to key-pass.txt"
echo "$PASS" > key-pass.txt
echo "Importing key first"
(sleep 2s; cat key-pass.txt; cat key-pass.txt; cat key-pass.txt ) | akash keys import default key.pem
echo "SUCCESS!"
./loop-payout.sh
