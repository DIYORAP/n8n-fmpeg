FROM n8nio/n8n:latest

# Switch to root to install system packages
USER root

# Install FFmpeg and required dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Verify FFmpeg installation
RUN ffmpeg -version

# Switch back to node user for security
USER node

# n8n will run with the node user from the base image
WORKDIR /home/node

