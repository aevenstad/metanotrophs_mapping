#!/bin/bash

#SBATCH --account=nn9549k
#SBATCH --job-name=concat
#SBATCH --time=5:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --cpus-per-task=1
#SBATCH --output=%x.%j.out


set -o errexit # exit on errors
set -o nounset # treat unset variables as errors


# Find all blast output files in blast directory
# merge output and filter out too short hsps
find $USERWORK/methanotrophs/blast_16S -type f -name "*blastout" \
-exec cat {} \; | \
awk '$4 >= 250' \
> methanotrophs_all_hits.blastout
