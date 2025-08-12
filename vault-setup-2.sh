#!/bin/bash
set -e

# Install Vault (latest)
echo "Downloading Vault..."
VAULT_VER=$(curl -s https://api.github.com/repos/hashicorp/vault/releases/latest | grep tag_name | cut -d '"' -f4)
curl -LO https://releases.hashicorp.com/vault/${VAULT_VER}/vault_${VAULT_VER#v}_linux_amd64.zip

# Unzip & install
unzip vault_${VAULT_VER#v}_linux_amd64.zip
sudo mv vault /usr/local/bin/
rm vault_${VAULT_VER#v}_linux_amd64.zip

# Verify Vault installation
vault --version

# Start Vault in dev mode
echo "Starting Vault server in dev mode..."
vault server -dev -dev-root-token-id="root" &
sleep 3

# Set environment variables
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='root'

vault status
