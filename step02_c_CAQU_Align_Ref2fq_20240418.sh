#! /bin/bash
#$ -l highp,h_rt=60:00:00,h_data=20G,h_vmem=200G
#$ -pe shared 10
#$ -wd <insert working directory path>
#$ -o <insert log directory path>
#$ -e <insert log directory path>
#$ -m abe
#$ -u 1joeynik
#$ -t <change to the file numbers depending on how many jobs you can simultaneously run>
#$ -N step02_c_CAQU_Align_Ref2fq_filesXXtoXX

# Version: v2 - running on new samples from 2024
# Usage: qsub step02_c_CAQU_Align_Ref2fq_20240418.sh
# Description:  Script to align re-sequencing data for CAQU to reference genome GCA_023055505.1_bCalCai1.0.p
# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Date: THU APR 18 2025

## Setup workspace 

sleep $((RANDOM % 120))
source <insert path to miniconda>
conda activate my_bwa

set -o pipefail

## Define variables 

WORKDIR=${HOMEDIR}/preprocessing/${NAME}
mkdir -p ${WORKDIR}

ROWID=$((SGE_TASK_ID + 1))
NAME=$(awk -v rowid=${ROWID} 'NR == rowid {print $1}' ${SEQDICT2024}) 
RGPU=$(awk -v rowid=${ROWID} 'NR == rowid {print $10}' ${SEQDICT2024}) 

## Main 

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Input =${RGPU} ${REF}; Starting to align using bwa-mem"

cd ${WORKDIR}
mkdir -p temp

# AlignCleanBam

bwa mem -M -t 15 -p -o ${RGPU}_${REF}_BWA_Aligned.bam \
${REFERENCE} ${RGPU}_MarkIlluminaAdapters.fastq 

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" 
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done" 

## CLEANUP  ##

conda deactivate
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done aligning"

