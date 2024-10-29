#! /bin/bash
#$ -l h_rt=23:00:00,h_data=16G,h_vmem=24G
#$ -wd /u/home/y/yhanyu/project-klohmuel/       # Set working directory
#$ -o /u/home/y/yhanyu/project-klohmuel/logs/job_output.log  # output log
#$ -e /u/home/y/yhanyu/project-klohmuel/logs/job_error.log   # error log
#$ -m abe
#$ -M yhanyu
#$ -N step02_a_CRLF_fastqc
#$ -t 1-12

# Version: v1
# Usage: qsub step02_a_CRLF_fastqc.sh
# Description: Run fastqc on CRLF fastq files
# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Adapted by: Hanyu Yang (yhy020321@g.ucla.edu)
# Date: Oct 24 2024

## Setup workspace 

sleep $((RANDOM % 120))

source /u/local/apps/anaconda3/2020.11/etc/profile.d/conda.sh
conda activate CRLF

set -xeo pipefail

## Define Variables 

HOMEDIR=/u/home/y/yhanyu/
WORKDIR=${HOMEDIR}/project-klohmuel/
SEQDIR=${WORKDIR}/CRLF_raw_data

# Subdirectories
mkdir -p ${SEQDIR}/fastqc
mkdir -p ${SEQDIR}/temp

# use a reference file
SEQDICT=${SEQDIR}/20220331_CRLF_seq_metadata.txt

# fastqc on forward reads and reverse reads
ROWID=$((SGE_TASK_ID + 1))
R1FILE=$(awk -v rowid=${ROWID} 'NR == rowid {print $2}' ${SEQDICT})
R2FILE=$(awk -v rowid=${ROWID} 'NR == rowid {print $3}' ${SEQDICT})

## Main 

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Starting fastqc"
cd ${SEQDIR}

fastqc "${R1FILE}" "${R2FILE}" -d ${SEQDIR}/temp -o ${SEQDIR}/fastqc

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" 
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with ${R1FILE} and ${R2FILE}"

## Clean up

conda deactivate
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done running fastqc"
