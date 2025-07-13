# STAR Alignment Tool Docker Image

![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=flat&logo=docker&logoColor=white)
![STAR](https://img.shields.io/badge/STAR-2.7.10a-blue)

A ready-to-use Docker image for [STAR](https://github.com/alexdobin/STAR) RNA-seq aligner with automatic reference genome indexing.

## Features

- Pre-built STAR v2.7.10a (Linux x86_64 static binary)
- Automatic reference genome indexing at container startup
- Multi-threading support
- Persistent index storage via volume mounts

## Quick Start

### Pull the Image
```bash
docker pull slgit.yutg.net/meng_rui/star:latest
```
### Basic Usage
```bash
docker run --rm \
  -v /path/to/your/data:/data \
  -e REFERENCE_GENOME=/data/genome.fa \
  slgit.yutg.net/meng_rui/star:latest \
  STAR \
  --readFilesIn /data/reads_1.fastq /data/reads_2.fastq \
  --outFileNamePrefix /data/output_
```
## Usage Guide

### Required Parameters
|Parameter	|Description
|-------|-------|
|REFERENCE_GENOME|	Path to reference genome FASTA file (must be mounted in container)
### Volume Mounts
Mount these directories for data persistence:

|Host Path	|Container Path	|Purpose|
|-------|-------|-------|
|/path/to/genome	|/data	|Contains reference genome and will store generated indices|
|/path/to/reads	|/data	|Input FASTQ files|
|/path/to/output	|/data	|Output alignment files|

### Example Commands

#### With Compressed Inputs

```bash
docker run --rm \
  -v /host/data:/data \
  -e REFERENCE_GENOME=/data/human_genome.fa \
  slgit.yutg.net/meng_rui/star:latest \
  STAR \
  --readFilesIn /data/sample_1.fastq.gz /data/sample_2.fastq.gz \
  --readFilesCommand zcat \
  --outSAMtype BAM SortedByCoordinate \
  --runThreadN 8
```
#### Using Existing Index

```bash
docker run --rm \
  -v /host/index:/data/index \
  -v /host/reads:/data/reads \
  slgit.yutg.net/meng_rui/star:latest \
  STAR \
  --genomeDir /data/index \
  --readFilesIn /data/reads/sample.fastq
```
## Advanced Configuration

### Environment Variables
|Variable	|Default	|Description|
|-------|-------|-------|
|REFERENCE_GENOME	|None|Path to reference genome (required)|
|THREADS	|$(nproc)	|Number of threads for indexing|
### Building Locally
#### Clone the repository
```bash
git clone https://slgit.yutg.net/Meng_Rui/STAR.git
cd STAR
```
#### Build the image:
```bash
docker build -t star-aligner .
```
## Technical Details

### Image Contents
- Ubuntu 22.04 base
- STAR v2.7.10a
- Required dependencies:
wget, build-essential
zlib1g-dev, unzip
### Entrypoint Behavior
- Checks for REFERENCE_GENOME environment variable
- Verifies if index exists at /data/index/SA
- Generates new index if needed
- Executes provided STAR command
### Troubleshooting

#### Slow Indexing
- Increase allocated CPU cores:
```bash
docker run --cpus=16 ...
```

## License
This Docker image is provided under MIT License.

STAR is licensed under GPLv3.
