# Akash Provider Withdrawal

The Akash Provider Withdrawal is a tool designed to automate the process of withdrawing funds from Akash Network leases. It is built using Shell scripting language and Docker, and it is designed to be run in a Docker container.

## Files
### Dockerfile

The Dockerfile is used to build the Docker image for the tool. It starts from the latest Golang base image, sets the working directory to /app, and installs necessary dependencies like git, jq, dnsutils, bsdmainutils, bc, and unzip. It also clones the Akash Network node repository and copies the Akash binary to /usr/local/bin. The Dockerfile then copies the start.sh and loop-payout.sh scripts into the Docker image and makes them executable. It also sets several environment variables that are used by the scripts.
### loop-payout.sh

This script is the main logic of the tool. It runs in an infinite loop, querying the Akash Network for active leases and checking their remaining balance. If the balance is negative, it initiates a withdrawal transaction. The script also includes checks to ensure that necessary command-line tools are installed and available.
### start.sh

This script sets up the environment for the tool to run. It sets several environment variables, including the Akash chain ID, node URL, keyring backend, and version. It also queries the Akash Network for the provider's address and writes the password to a file called key-pass.txt. The script then imports the key from the key.pem file and starts the loop-payout.sh script.
## Usage

To run the tool, use the following command:

```
docker run -it --mount type=bind,source="$(pwd)"/key.pem,target=/app/key.pem,readonly --env ONLY_NEGATIVE_BALANCES=false --env PASS=replace_with_key_pem_pass --env PROVIDER=yourprovider.com cryptoandcoffee/akash-provider-withdrawal
```
Replace replace_with_key_pem_pass with the password for your key.pem file and yourprovider.com with your provider's domain name.

