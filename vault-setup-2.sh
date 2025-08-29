#!/bin/bash
set -e

# Use a fixed Vault version for stability in CI
VAULT_VER="1.20.2"
VAULT_ZIP="vault_${VAULT_VER}_linux_amd64.zip"

# Download Vault
echo "Downloading Vault version $VAULT_VER..."
curl -LO "https://releases.hashicorp.com/vault/${VAULT_VER}/${VAULT_ZIP}"

# Unzip & move binary
unzip -o $VAULT_ZIP
mkdir -p ~/bin
mv vault ~/bin/
export PATH=$PATH:~/bin

# Clean up
rm $VAULT_ZIP

# Verify Vault installation
vault --version

# Start Vault in dev mode (in background)
echo "Starting Vault server in dev mode..."
nohup vault server -dev -dev-root-token-id="root" > vault.log 2>&1 &

# Wait a few seconds for Vault to start
sleep 5

# Set environment variables for this build step
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='root'

# Check Vault status
vault status
