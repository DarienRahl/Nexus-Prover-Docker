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
