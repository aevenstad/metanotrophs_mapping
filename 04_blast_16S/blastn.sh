#!/bin/bash

# SLURM OPTIONS
#SBATCH --account=nn9549k
#SBATCH --job-name=blastn_16S_round1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --cpus-per-task=1
#SBATCH --output=logs/%x.%j.out


# Set error handling
set -o errexit # exit on errors
set -o nounset # treat unset variables as errors


### LOAD  MODULES ###
module --quiet purge
module load BLAST+/2.14.1-gompi-2023a

# Set variables
FASTA_PATH=/cluster/work/users/andreeve/methanotrophs/$1
DB_PATH=/cluster/projects/nn9549k/Andreas/methanotroph_project/16S_methanotrophs/16S_methanotrophs
OUT_DIR=/cluster/work/users/andreeve/methanotrophs/blast_16S/$2
DB_NAME=$(basename ${DB_PATH})


# Pipe uncompressed fasta to blast search
gzip -dc ${FASTA_PATH}${QUERY} | \
blastn -query - \
-db ${DB_PATH} \
-outfmt 6 \
-max_hsps 1 \
-perc_identity 99 \
-evalue 1e-100 \
-num_threads $SLURM_CPUS_PER_TASK \
-out ${OUT_DIR}/${QUERY_NAME}_${DB_NAME}.blastout

echo "Blast complete for $QUERY"
