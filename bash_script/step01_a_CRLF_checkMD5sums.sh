#!/bin/bash
#$ -l h_data=4G,h_rt=6:00:00
#$ -wd /u/home/y/yhanyu/project-klohmuel/CRLF_raw_data        # Set working directory
#$ -o /u/home/y/yhanyu/project-klohmuel/logs/job_output.log  # output log
#$ -e /u/home/y/yhanyu/project-klohmuel/logs/job_error.log   # error log
#$ -m abe
#$ -N step01_a_CRLF_checkMD5sums

# Version: v1
# Usage: qsub step01_a_CRLF_checkMD5sums.sh
# Description: Check if file transfer was successful using MD5
# Author: Hanyu Yang (yhy020321@g.ucla.edu)
# Date: OCT 18 2024

## Setup workspace

# Load the Miniconda environment
source /u/local/apps/anaconda3/2020.11/etc/profile.d/conda.sh
conda activate CRLF

# Set script to exit immediately on error and print commands
set -xeo pipefail

# working directories
WORKDIR=/u/home/y/yhanyu/project-klohmuel/CRLF_raw_data

## Main

# Check current MD5 against what was given to me by the sequencing facility
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}: CHECKING MD5 SUMS FOR DOWNLOADED DATA..."
cd ${WORKDIR}
md5sum --check md5sum.txt

exitVal=${?}    #capture exit status
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done"

## Cleanup

# Add success to program log
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done with MD5sums"
