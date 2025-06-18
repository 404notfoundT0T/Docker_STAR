#!/bin/bash
# entrypoint.sh

set -e

# Check if reference genome exists
if [ -z "$REFERENCE_GENOME" ]; then
    echo "Error: REFERENCE_GENOME environment variable not set" >&2
    exit 1
fi

# Check if index exists
if [ ! -f "/data/index/SA" ]; then
    echo "Generating STAR index..."
    
    # Create parent directory if needed
    mkdir -p $(dirname "$REFERENCE_GENOME")
    
    STAR \
        --runMode genomeGenerate \
        --genomeDir /data/index \
        --genomeFastaFiles "$REFERENCE_GENOME" \
        --runThreadN $(nproc)
    
    echo "Index generation complete"
else
    echo "Using existing index"
fi

# Execute the command
exec "$@"
