# 💰 Akash Provider Withdrawal: Automate Your Akash Network Lease Withdrawals

Welcome to the Akash Provider Withdrawal tool! This tool is a must-have for all [Akash Providers](https://docs.akash.network/providers). It's designed to automate the process of withdrawing funds from your Akash Network leases. Built using Shell scripting language and Docker, it's designed to run smoothly in a Docker container. 🐳

## 🎁 Benefits of Using the App

The Akash Provider Withdrawal tool offers several benefits:
- **Automation**: The tool automates the process of withdrawing funds from leases, saving you time and effort.
- **Flexibility**: You can configure the tool's operation using environment variables, allowing you to customize it to suit your needs.
- **Ease of Use**: The tool is designed to be run in a Docker container, making it easy to set up and use. 
   
## 📁 Files

### Dockerfile 📄

The Dockerfile is the blueprint for building the Docker image for the tool. It starts from the latest Golang base image, sets the working directory to /app, and installs essential dependencies. It also clones the [Akash Network node repository](https://github.com/akash-network/node) and prepares the environment for the scripts to run.

### loop-payout.sh 💸

This script is the heart of the tool. It runs in an infinite loop, querying the Akash Network for active leases and checking their remaining balance. If the balance is negative, it initiates a withdrawal transaction. The script also includes checks to ensure that necessary command-line tools are installed and available.

### start.sh 🏁

This script sets up the environment for the tool to run. It sets several environment variables, including the Akash chain ID, node URL, keyring backend, and version. It also queries the Akash Network for the provider's address and prepares the environment for the loop-payout.sh script to run.

## 🏃‍♂️ Usage

To run the tool, use the following command:

### To run the tool, use the following command:

```
docker run -it \
  --mount type=bind,source="$(pwd)"/key.pem,target=/app/key.pem,readonly \
  --env PASS=replace_with_key_pem_pass \
  --env ONLY_NEGATIVE_BALANCES=false \
  --env PROVIDER=yourprovider.com \
  --env FEE=4000 \
  cryptoandcoffee/akash-provider-withdrawal
```
Replace replace_with_key_pem_pass with the password for your key.pem file and yourprovider.com with your provider's domain name.

*If you can't find your key.pem or password - you can get it from your running provider pod and save it locally!

```
kubectl cp akash-services/akash-provider-0:/boot-keys/key.txt ./key.pem
kubectl cp akash-services/akash-provider-0:/boot-keys/key-pass.txt ./key-pass.txt
```

## 🌍 Environment Variables

During runtime, you can set several environment variables to configure the behavior of the Akash Provider Withdrawal tool. These variables allow you to customize the tool's operation to suit your needs. Add them with --env to the docker run command in Usage section.

- `PASS`: Set to the password for your key.pem file. **Required**
- `PROVIDER`: Set to your provider's domain name. **Required**
- `ONLY_NEGATIVE_BALANCES`: Set to true to only withdraw from leases with negative balances, and false to withdraw from all leases. Default is false. Optional
- `NODE`: Specify the Akash node to connect to. Optional
- `MODE`: Specify the mode of operation. The default value is `block`. Optional
- `FEE`: Specify the fee (in UAKT) to use for each payout. If the fee is too low, you may encounter errors. Optional
- `DELAY`: Specify the delay (in seconds) between each payout. Optional

## 🛠️ Building from Source

To build the Akash Provider Withdrawal tool from source, follow these steps:

1. Clone the repository: `git clone https://github.com/88plug/akash-provider-withdrawal.git`
2. Navigate to the cloned directory: `cd akash-provider-withdrawal`
3. Build the Docker image: `docker build -t akash-provider-withdrawal .`

Now, you can run the tool using the `docker run` command mentioned in the Usage section.

