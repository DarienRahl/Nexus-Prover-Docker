
# Nexus-Prover Docker Installation Guide

This repository provides a Docker setup for installing and running the Nexus-Prover. Follow these steps to build and run the Docker container for Nexus-Prover on your system.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed on your system. You can follow the instructions for your platform on Docker's official website.

### Docker Installation (Optional)

If you don’t have Docker installed yet, you can install it by running the following commands for Ubuntu:

```bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
```

For other platforms, please refer to the official Docker [installation guide](https://docs.docker.com/get-docker/).

## Cloning the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/yourusername/nexus-prover-docker.git
cd nexus-prover-docker
```

## Building the Docker Image

To build the Docker image, navigate to the folder containing the `Dockerfile` and run the following command:

```bash
docker build -t nexus-prover .
```

This will create a Docker image with the necessary dependencies and configuration to run Nexus-Prover.

## Running the Nexus-Prover Container

Once the image has been built, you can run the container in the background (detached mode) with:

```bash
docker run -d nexus-prover
```

The container will now run Nexus-Prover in the background. You can check if it's running using:

```bash
docker ps
```

## Stopping the Container

To stop the container, first list the running containers to get the `CONTAINER ID`:

```bash
docker ps
```

Then, use the `docker stop` command followed by the `CONTAINER ID`:

```bash
docker stop <CONTAINER ID>
```

## Updating the Nexus-Prover Code

If you need to update the Nexus-Prover repository inside the container, follow these steps:

1. Enter the running container by executing:

```bash
docker exec -it <CONTAINER ID> /bin/bash
```

2. Navigate to the `network-api` directory and pull the latest changes:

```bash
cd ~/.nexus/network-api
git pull
```

3. Restart the `prover` by navigating to the CLI client directory and running the prover:

```bash
cd clients/cli
cargo run --release --bin prover -- beta.orchestrator.nexus.xyz
```

## Customizing the Dockerfile

The `Dockerfile` included in this repository installs all the required dependencies for Nexus-Prover, sets up Rust, and runs the prover script. If you need to make modifications (e.g., adding more dependencies), feel free to edit the `Dockerfile` accordingly.

## Full Dockerfile Overview

```Dockerfile
# Use the base image from Ubuntu
FROM ubuntu:20.04

# Set the environment variable to automatically approve package installations
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    iptables \
    build-essential \
    git \
    wget \
    lz4 \
    jq \
    make \
    gcc \
    nano \
    automake \
    autoconf \
    tmux \
    htop \
    nvme-cli \
    pkg-config \
    libssl-dev \
    libleveldb-dev \
    tar \
    clang \
    bsdmainutils \
    ncdu \
    unzip \
    curl

# Install Rust using rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Add Rust to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Update Rust and check the version
RUN rustup update
RUN rustc --version

# Create a directory for Nexus-Prover and copy the launch script
WORKDIR /root

# Add the launch script to the container
COPY run_nexus_prover.sh /root/run_nexus_prover.sh

# Grant execute permissions to the script
RUN chmod +x /root/run_nexus_prover.sh

# Run the script when the container starts
CMD ["/root/run_nexus_prover.sh"]
```

## Issues and Support

If you encounter any issues or need help, feel free to open an issue on this repository, and I will assist you as soon as possible.
