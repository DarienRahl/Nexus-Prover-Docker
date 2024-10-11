#!/bin/sh

# Check if Rust is installed, otherwise install it
rustc --version || curl https://sh.rustup.rs -sSf | sh

# Set environment variable for Nexus-Prover
NEXUS_HOME=$HOME/.nexus

# Prompt for agreement to the terms of service
while [ -z "$NONINTERACTIVE" ]; do
    read -p "Do you agree to the Nexus Beta Terms of Use (https://nexus.xyz/terms-of-use)? (Y/n) " yn </dev/tty
    case $yn in
        [Nn]* ) exit;;
        [Yy]* ) break;;
        "" ) break;;
        * ) echo "Please answer yes or no.";;
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
  echo "$NEXUS_HOME/network-api exists. Updating.";
  (cd $NEXUS_HOME/network-api && git pull)
else
  mkdir -p $NEXUS_HOME
  (cd $NEXUS_HOME && git clone https://github.com/nexus-xyz/network-api)
fi

# Run Nexus-Prover
(cd $NEXUS_HOME/network-api/clients/cli && cargo run --release --bin prover -- beta.orchestrator.nexus.xyz)
