#!/bin/bash
#$ -l h_rt=6:00:00,h_data=12G
#$ -pe shared 2
#$ -wd /u/home/y/yhanyu/project-klohmuel/CRLF_raw_data        # Set working directory
#$ -o /u/home/y/yhanyu/project-klohmuel/logs/job_output.log  # output log
#$ -e /u/home/y/yhanyu/project-klohmuel/logs/job_error.log   # error log
#$ -M yhanyu
#$ -m abe
#$ -N step01_d_CRLF_catMultiLaneData

# Version: v1
# Usage: qsub step01_d_CRLF_catMultiLaneData.sh <sample_id_1> <sample_id_2> ...
# Description: Concatenate raw data originating from multiple lanes of sequencing for multiple samples
# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Adapted by: Hanyu Yang (yhy020321@g.ucla.edu)
# Date: Oct 24 2024
# References:
# https://knowledge.illumina.com/software/cloud-software/software-cloud-software-reference_material-list/000002035

## Setup workspace

set -xeo pipefail

## Define variables

WORKDIR=/u/home/y/yhanyu/project-klohmuel/CRLF_raw_data

## Main

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Starting to cat multi lane data for samples: $*"
cd ${WORKDIR}

# Loop over each sample ID
for id in "$@"; do
  echo -e "[$(date "+%Y-%m-%d %T")] Processing sample ${id}"

  # forward reads (R1)
  cat "${id}"_R1*.fq.gz > "${id}"_R1.fq.gz
  # reverse reads (R2)
  cat "${id}"_R2*.fq.gz > "${id}"_R2.fq.gz

  exitVal=${?}
  if [ ${exitVal} -ne 0 ]; then
      echo -e "[$(date "+%Y-%m-%d %T")] FAIL for sample ${id}"
      exit 1
  fi
done

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Done processing all samples"

## Cleanup

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID} Done concatenating multi lane data for all samples"
