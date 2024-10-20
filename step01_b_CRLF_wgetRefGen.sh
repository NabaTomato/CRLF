#!/bin/bash
#$ -l highp,h_data=4G,h_rt=6:00:00
#$ -wd <insert path to working directory>
#$ -o <insert path to log directory>
#$ -e <insert path to log directory>
#$ -m abe
#$ -N step01_step01_b_CAQU_wgetRefGen

# Version: v1
# Usage: qsub step01_step01_b_CAQU_wgetRefGen_20221103.sh
# Description: Download California quail reference genome from NCBI
# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Date: WED NOV 03 2022

## setup workspace

source <path to miniconda>
conda activate CRLF

set -xeo pipefail

## Define Variables

WORKDIR=/u/project/rwayne/1joeynik/CAQU/ref_genome/GCA_023055505.1_bCalCai1.0.p
AR_REFERENCE_SEQ=GCA_023055505.1_bCalCai1.0.p_genomic.fna.gz  # to archive
REFERENCE_SEQ=GCA_023055505.1_bCalCai1.0.p_genomic.fasta

## Main

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}: Download Reference Genome for California Quail..."
cd ${WORKDIR}

wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/023/055/505/GCA_023055505.1_bCalCai1.0.p/GCA_023055505.1_bCalCai1.0.p*

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" >> ${LOG}
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done"

# gunzip file

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Gunzip reference seq"

cp ${AR_REFERENCE_SEQ} ${AR_REFERENCE_SEQ/.fna.gz/.fasta.gz}
gunzip ${REFERENCE_SEQ}.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" >> ${LOG}
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done "

## Cleanup ##

conda deactivate
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done downloading and gunzipping reference seq"