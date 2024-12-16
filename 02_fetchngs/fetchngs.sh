#!/bin/bash

# Load and activate Miniconda and activate nextflow env
module load Miniconda3/22.11.1-1
source ${EBROOTMINICONDA3}/bin/activate
conda activate nextflow_23.10


# Set singularity cache dir
export APPTAINER_CACHEDIR=/cluster/work/users/andreeve/.apptainer


# Run pipeline in the backgound
nohup nextflow run nf-core/fetchngs \
        -r 1.12.0 \
        -profile singularity \
        -c local.config \
        -work-dir ${USERWORK}/fetchngs_work \
        --input SRA_samplesheet.csv \
        --outdir fetchngs_out \
        --nf_core_pipeline taxprofiler \
        --download_method sratools \
        &
