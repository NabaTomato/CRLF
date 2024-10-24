#! /bin/bash
#$ -l h_rt=23:00:00,h_data=16G,h_vmem=24G
#$ -wd <insert working directory path>
#$ -o <insert log directory path>
#$ -e <insert log directory path>
#$ -m abe
#$ -M 1joeynik
#$ -N step02_a_CAQU_fastqc
#$ -t <change according to how many files you are running this on>

# Version: v2 running on 2024 sequenced samplese
# Usage: qsub step02_a_CRLF_fastqc.sh
# Description: Run fastqc on CAQU fastq files
# Author: Joey Curti (jcurti3@g.ucla.edu)
# Date: THUR APR 04 2024

## Setup workspace 

sleep $((RANDOM % 120))

source <insert path to miniconda>
conda activate my_fastqc 

set -eo pipefail

## Define Variables 

HOMEDIR=/u/home/1/1joeynik/project-rwayne/CAQU/
SEQDIR=/u/home/1/1joeynik/project-rwayne/CAQU/raw_data/2024_samples

# Subdirectories
mkdir -p ${SEQDIR}/fastqc
mkdir -p ${SEQDIR}/temp

# use a reference file
SEQDICT=${HOMEDIR}/raw_data/20240409_CAQU_seq_metadata.txt

# first line of fastq
FIRSTLINE=${SEQDIR}/first_fastq_lines.txt

# fastqc on forward reads and reverse reads
ROWID=$((SGE_TASK_ID + 1))
R1FILE=$(awk -v rowid=${ROWID} 'NR == rowid {print $2}' ${SEQDICT})
R2FILE=$(awk -v rowid=${ROWID} 'NR == rowid {print $3}' ${SEQDICT})

## Main 

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Starting fastqc"
cd ${SEQDIR}

fastqc ${R1FILE} ${R2FILE} -d ./temp --outdir ${SEQDIR}/fastqc

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" 
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with ${R1FILE} and ${R2FILE}"

## Clean up

conda deactivate
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done running fastqc"
