#! /bin/bash
#$ -l highp,h_rt=60:00:00,h_data=20G,h_vmem=200G
#$ -pe shared 10
#$ -wd /u/home/y/yhanyu/project-klohmuel/CRLF_raw_data       # Set working directory
#$ -o /u/home/y/yhanyu/project-klohmuel/logs/job_output.log  # output log
#$ -e /u/home/y/yhanyu/project-klohmuel/logs/job_error.log   # error log
#$ -m abe
#$ -M yhanyu
#$ -t 1-12
# $ -N step02_c_CRLF_Align_Ref2fq

# Version: v1
# Usage: qsub step02_c_CRLF_Align_Ref2fq.sh
# Description:  Script to align re-sequencing data for CRLF to reference genome GCA_029206835.1_Rmu.v1_genomic.fasta
# Author: Hanyu Yang (yhy020321@g.ucla.edu)
# Date: Oct 27 2024

## Setup workspace 

sleep $((RANDOM % 120))

source /u/local/apps/anaconda3/2020.11/etc/profile.d/conda.sh
conda activate CRLF

set -xeo pipefail

## Define variables

HOMEDIR=/u/home/y/yhanyu/
WORKDIR=${HOMEDIR}/project-klohmuel/CRLF_raw_data/Preprocessing/${NAME}
SEQDICT=${HOMEDIR}/project-klohmuel/CRLF_raw_data/20220331_CRLF_seq_metadata.txt
REF='Rmuscosa'
REFERENCE=/${HOMEDIR}/project-klohmuel/ref_genome/GCA_029206835.1_Rmu.v1_genomic.fasta

mkdir -p "${WORKDIR}"

ROWID=$((SGE_TASK_ID + 1))
NAME=$(awk -v rowid=${ROWID} 'NR == rowid {print $1}' "${SEQDICT}")

## Main 

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Input =${NAME} ${REF}; Starting to align using bwa-mem"

cd "${WORKDIR}"
mkdir -p temp

# AlignCleanBam

bwa mem -M -t 15 -p -o "${NAME}"_"${REF}"_BWA_Aligned.bam \
"${REFERENCE}" "${NAME}"_MarkAdapters.fastq

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" 
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done" 

## CLEANUP  ##

conda deactivate
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done aligning"

