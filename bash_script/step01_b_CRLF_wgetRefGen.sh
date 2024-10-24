#!/bin/bash
#$ -l highp,h_data=4G,h_rt=6:00:00
#$ -wd /u/home/y/yhanyu/project-klohmuel/ref_genome       # Set working directory
#$ -o /u/home/y/yhanyu/project-klohmuel/logs/job_output.log  # output log
#$ -e /u/home/y/yhanyu/project-klohmuel/logs/job_error.log   # error log
#$ -m abe
#$ -N step01_b_CRLF_wgetRefGen

# Version: v1
# Usage: qsub step01_b_CRLF_wgetRefGen.sh
# Description: Download CRLF reference genome (Rana muscosa) from NCBI
# Author: Hanyu Yang (yhy020321@g.ucla.edu)
# Date: Oct 21 2024

## setup workspace

# Load the Miniconda environment
source /u/local/apps/anaconda3/2020.11/etc/profile.d/conda.sh
conda activate CRLF

set -xeo pipefail

## Define Variables

WORKDIR=/u/home/y/yhanyu/project-klohmuel/ref_genome
AR_REFERENCE_SEQ=GCA_029206835.1_Rmu.v1_genomic.fna.gz  # to archive
REFERENCE_SEQ=GCA_029206835.1_Rmu.v1_genomic.fasta

## Main

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}: Download Reference Genome for CRLF..."
cd ${WORKDIR}

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/029/206/835/GCA_029206835.1_Rmu.v1/GCA_029206835.1_Rmu.v1_genomic.fna.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" >> "${LOG}"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done"

# gunzip file

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Gunzip reference seq"

cp ${AR_REFERENCE_SEQ} ${AR_REFERENCE_SEQ/.fna.gz/.fasta.gz}
gunzip ${REFERENCE_SEQ}.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" >> "${LOG}"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done "

## Cleanup ##

conda deactivate
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done downloading and gunzipping reference seq"