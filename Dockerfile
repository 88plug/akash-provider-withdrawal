# Start from the latest golang base image
FROM golang:latest

# Set the Current Working Directory inside the container
WORKDIR /app

# Install git
RUN apt-get update && apt-get install -y git jq dnsutils bsdmainutils bc unzip

#Install Akash and setup wallet
RUN curl -sSfL https://raw.githubusercontent.com/akash-network/node/master/install.sh | sh
RUN cp bin/akash /usr/local/bin
RUN rm -rf bin/
RUN curl -sfL https://raw.githubusercontent.com/akash-network/provider/main/install.sh | bash
RUN cp bin/provider-services /usr/local/bin
RUN rm -rf bin/
RUN echo "Akash Node     : $(akash version)\nAkash Provider : $(provider-services version)"

# Clone the repository
RUN curl -sSfL https://raw.githubusercontent.com/akash-network/node/master/install.sh | sh
RUN cp bin/akash /usr/local/bin/

# Copy the scripts into the Docker image
COPY start.sh /app/start.sh
COPY loop-payout.sh /app/loop-payout.sh

# Grant permissions for the script to be executable
RUN chmod +x /app/start.sh
RUN chmod +x /app/loop-payout.sh

ENV NODE=https://akash-rpc.global.ssl.fastly.net:443
ENV PASS=
# Password to the private key
ENV PROVIDER=
# Provider domain name
ENV MODE=block
ENV FEE=69
# UAKT Fee to use for each payout. You will likely get errors if too low.
ENV ONLY_NEGATIVE_BALANCES=true
# Change to true to withdrawl all leases including positive balances.
ENV DELAY=15
# Delay between each payout
ENV CLOSE_ALL=false
# Close all bids (close all deployments)

# Set the start script as the entrypoint
ENTRYPOINT ["bash", "/app/start.sh"]
