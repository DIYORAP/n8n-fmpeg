FROM n8nio/n8n:latest

USER root

# Install FFmpeg
RUN apt-get update && apt-get install -y ffmpeg && apt-get clean

USER node
