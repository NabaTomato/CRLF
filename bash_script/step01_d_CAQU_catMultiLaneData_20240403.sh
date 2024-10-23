#!/bin/bash
#$ -l h_rt=6:00:00,h_data=12G
#$ -pe shared 2
#$ -wd /u/home/y/yhanyu/project-klohmuel/CRLF_raw_data        # Set working directory
#$ -o /u/home/y/yhanyu/project-klohmuel/logs/job_output.log  # output log
#$ -e /u/home/y/yhanyu/project-klohmuel/logs/job_error.log   # error log
#$ -M 1joeynik
#$ -m bea
#$ -N step01_d_CAQU_catMultiLaneData

# Version: v2 - New files from 2024 sequencing
# Usage:  qsub step01_d_CAQU_catMultiLaneData_20240403.sh
# Description:  Concatenate raw data originating from multiple lanes of sequencing
# Author: Joey Curti (jcurti3@g.ucla.edu)
# Date: THUR APR 04 2024
# References: 
# https://knowledge.illumina.com/software/cloud-software/software-cloud-software-reference_material-list/000002035

## Setup workspace

set -xeo pipefail

## Define variables 

WORKDIR=/u/home/y/yhanyu/project-klohmuel/CRLF_raw_data

## Main 

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Starting to cat multilane data" 
cd ${WORKDIR}

# loop over individuals and concatenate the raw data
# T4B005

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Forward read T4B005"

cat T4B005_ZKDN230030242-1A_HVVV3DSX7_L4_1.fq.gz T4B005_ZKDN230030242-1A_HVTJTDSX7_L4_1.fq.gz > T4B005_cat_R1.fq.gz 

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" 
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Done with forward read T4B005"

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Reverse read T4B005"

cat T4B005_ZKDN230030242-1A_HVVV3DSX7_L4_2.fq.gz T4B005_ZKDN230030242-1A_HVTJTDSX7_L4_2.fq.gz > T4B005_cat_R2.fq.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" 
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Done with reverse read T4B005"

# T2B087

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Forward read T2B087"

cat T2B087_ZKDN230030221-1A_HVVV3DSX7_L2_1.fq.gz T2B087_ZKDN230030221-1A_HVTJTDSX7_L4_1.fq.gz > T2B087_cat_R1.fq.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" 
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Done with forward read T2B087"

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Reverse read T2B087"

cat T2B087_ZKDN230030221-1A_HVVV3DSX7_L2_2.fq.gz T2B087_ZKDN230030221-1A_HVTJTDSX7_L4_2.fq.gz > T2B087_cat_R2.fq.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Done with reverse read T2B087"

# T3B092

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; T3B092"

inds=(T3B092)
for i in "${inds[@]}"; do
 cat ${i}*_R1* > ${i}_S17_L001_R1_001.fq.gz 
 cat ${i}*_R2* > ${i}_S17_L001_R2_001.fq.gz
done

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Done with T3B092"

## Cleanup ##

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID} Done concatenating multilane data"
