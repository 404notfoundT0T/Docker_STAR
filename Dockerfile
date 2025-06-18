# Dockerfile
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    build-essential \
    zlib1g-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install STAR
RUN wget https://github.com/alexdobin/STAR/archive/2.7.10a.tar.gz && \
    tar -xzf 2.7.10a.tar.gz && \
    mv STAR-2.7.10a/bin/Linux_x86_64_static/STAR /usr/local/bin/ && \
    rm -rf 2.7.10a.tar.gz STAR-2.7.10a

# Create data directory
RUN mkdir -p /data/index

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
