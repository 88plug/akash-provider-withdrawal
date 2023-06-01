#!/bin/bash

# Check if PASS variable is defined
if [[ -z "$PASS" ]]; then
  echo "❌ ERROR: PASS variable is not defined"
  exit 1
fi

# Check if key.pem file exists
if [[ ! -f "key.pem" ]]; then
  echo "❌ ERROR: key.pem file does not exist"
  exit 1
fi

# Environment variables setup
export AKASH_CHAIN_ID=akashnet-2
export AKASH_NODE=$NODE
export AKASH_KEYRING_BACKEND=os
export AKASH_VERSION=0.22.6
export AKASH_NET=https://raw.githubusercontent.com/ovrclk/net/master/mainnet
export AKASH_KEY_NAME=default
export AKASH_SECRET=$PASS

# Retrieve AKASH_ACCOUNT_ADDRESS
AKASH_ACCOUNT_ADDRESS=$(akash query provider list -o json --limit 10000 --node $NODE | jq -r '.providers[] | select(.host_uri | contains("'"$PROVIDER"'")) | .owner')
if [ -z "$AKASH_ACCOUNT_ADDRESS" ]; then
    echo "❌ Failed to find Akash provider address for $PROVIDER"
    exit 1
fi
echo "🔍 Found Akash provider address $PROVIDER"
export PROVIDER=$AKASH_ACCOUNT_ADDRESS

# Write password to 'key-pass.txt'
echo "💾 Adding password to key-pass.txt"
echo "$PASS" > key-pass.txt

# Import key
echo "🔑 Importing key first"
if ! (sleep 2s; cat key-pass.txt; cat key-pass.txt; cat key-pass.txt) | akash keys import default key.pem; then
    echo "❌ Failed to import key"
    exit 1
fi

# Display success message
echo "✅ SUCCESS!"

# Execute loop-payout.sh script
if ! ./loop-payout.sh; then
    echo "❌ Failed to execute loop-payout.sh"
    exit 1
fi
