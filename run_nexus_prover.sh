#!/bin/sh

# Check if Rust is installed; if not, install it
rustc --version || curl https://sh.rustup.rs -sSf | sh

# Set environment variable for Nexus-Prover
NEXUS_HOME=$HOME/.nexus

# Prompt for agreement to the Terms of Use
while [ -z "$NONINTERACTIVE" ]; do
    read -p "Do you agree to the Nexus Beta Terms of Use (https://nexus.xyz/terms-of-use)? (Y/n) " yn </dev/tty
    case $yn in
        [Nn]* ) exit;;
        [Yy]* ) break;;
        "" ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Ask for provider-id and save it to a file
while true; do
    read -p "Do you have a provider-id? (Y/n) " has_provider_id </dev/tty
    case $has_provider_id in
        [Yy]* )
            read -p "Please enter your provider-id: " PROVIDER_ID </dev/tty
            mkdir -p "$NEXUS_HOME"
            echo "$PROVIDER_ID" > "$NEXUS_HOME/prover-id"
            break;;
        [Nn]* )
            echo "Provider-id not provided. Continuing without it."
            break;;
        "" ) echo "Please answer yes or no.";;
    esac
done

# Check if git is installed
git --version 2>&1 >/dev/null
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE != 0 ]; then
  echo "Unable to find git. Please install it and try again."
  exit 1;
fi

# Update or clone the Nexus-Prover repository
if [ -d "$NEXUS_HOME/network-api" ]; then
  echo "$NEXUS_HOME/network-api exists. Updating."
  (cd $NEXUS_HOME/network-api && git pull)
else
  mkdir -p $NEXUS_HOME
  (cd $NEXUS_HOME && git clone https://github.com/nexus-xyz/network-api)
fi

# Run Nexus-Prover with loaded provider-id if available
if [ -f "$NEXUS_HOME/prover-id" ]; then
  PROVIDER_ID=$(cat "$NEXUS_HOME/prover-id")
  (cd $NEXUS_HOME/network-api/clients/cli && cargo run --release --bin prover -- beta.orchestrator.nexus.xyz --provider-id=$PROVIDER_ID)
else
  (cd $NEXUS_HOME/network-api/clients/cli && cargo run --release --bin prover -- beta.orchestrator.nexus.xyz)
fi
