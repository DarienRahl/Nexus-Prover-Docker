
# Nexus-Prover Docker Installation Guide

This guide will walk you through installing and running Nexus-Prover using Docker. It’s divided into two main sections:
1. **Setting up Docker and building the Nexus-Prover Docker image**
2. **Running, monitoring, and managing the Docker container**

---

## Prerequisites

Before you begin, make sure you have **Docker** installed on your machine. If not, follow the instructions below.

### Step 1: Docker Installation (Optional)

If Docker is not installed, use the following commands to install Docker on Ubuntu:

```bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
```

For other platforms, refer to the official [Docker installation guide](https://docs.docker.com/get-docker/).

---

## Step 2: Cloning the Repository

Next, clone this repository to your local machine:

```bash
git clone https://github.com/darienrahl/nexus-prover-docker.git
cd nexus-prover-docker
```

---

## Step 3: Building the Docker Image

Navigate to the folder where the `Dockerfile` is located and build the Docker image using the following command:

```bash
docker build -t nexus-prover .
```

This command will create a Docker image with all the necessary dependencies for running Nexus-Prover.

---

# Running and Managing Nexus-Prover Docker Container

---

## Step 4: Running the Nexus-Prover Container in Detached Mode

To run the Docker container in the background (detached mode), execute:

```bash
docker run -d nexus-prover
```

The container will now be running in the background.

---

## Step 5: Monitoring the Nexus-Prover Docker Container

Once the container is running, you may want to monitor its logs and check the status of the container.

### Viewing Container Logs

To view logs, use the following command:

```bash
docker logs <CONTAINER ID or NAME>
```

To follow the logs in real-time, use:

```bash
docker logs -f <CONTAINER ID or NAME>
```

### Attaching to a Running Container

If you need to interact with the running container, you can attach to it using:

```bash
docker exec -it <CONTAINER ID or NAME> /bin/bash
```

### Checking Container Status

To check the status of the container, run:

```bash
docker ps
```

This will list all running containers. If the container is stopped, use:

```bash
docker ps -a
```

---

## Step 6: Stopping the Docker Container

To stop the Nexus-Prover container, use:

```bash
docker stop <CONTAINER ID>
```

---

# Updating the Nexus-Prover Code

If you need to update the Nexus-Prover code within the container, follow these steps:

1. Enter the running container:
   ```bash
   docker exec -it <CONTAINER ID> /bin/bash
   ```

2. Navigate to the `network-api` directory and pull the latest changes:
   ```bash
   cd ~/.nexus/network-api
   git pull
   ```

3. Restart the `prover` by running:
   ```bash
   cd clients/cli
   cargo run --release --bin prover -- beta.orchestrator.nexus.xyz
   ```

---

## Step 7: Customizing the Dockerfile

The `Dockerfile` installs all the required dependencies for Nexus-Prover and runs the prover script. You can modify the `Dockerfile` to add any additional dependencies you may need.

Here's the Dockerfile included in this repository:

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

---

## Issues and Support

If you encounter any issues or need assistance, feel free to open an issue on this repository.

---
