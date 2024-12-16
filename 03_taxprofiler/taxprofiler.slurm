#!/bin/bash
#SBATCH --account=nn9549k
#SBATCH --job-name=taxprofiler
#SBATCH --time=100:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=1
#SBATCH --output=%x.%j.out

## ABORT IF ANY ERROR ##
set -e


### LOAD  MODULES ###
module purge

### CONDA ENV ###

module load Miniconda3/22.11.1-1
export PS1=\$
source ${EBROOTMINICONDA3}/etc/profile.d/conda.sh
conda deactivate &>/dev/null
conda activate nextflow_23.10


IN=samplesheet_taxprofiler_final.csv
OUT=taxprofiler_out
WORK=taxprofiler_work

nextflow run nf-core/taxprofiler \
-profile singularity \
--input $IN \
--outdir $OUT \
--databases databases.csv \
--save_analysis_ready_fastqs \
--skip_preprocessing_qc \
--perform_shortread_qc \
--perform_runmerging \
--save_runmerged_reads \
--shortread_qc_mergepairs \
-work-dir $WORK \
-resume \
-c local.config
