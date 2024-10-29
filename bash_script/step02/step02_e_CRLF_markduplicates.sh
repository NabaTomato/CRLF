#! /bin/bash
#$ -l highp,h_rt=120:00:00,h_data=8G,h_vmem=64G
#$ -pe shared 8
#$ -wd /u/home/y/yhanyu/project-klohmuel/CRLF_raw_data       # Set working directory
#$ -o /u/home/y/yhanyu/project-klohmuel/logs/job_output.log  # output log
#$ -e /u/home/y/yhanyu/project-klohmuel/logs/job_error.log   # error log
#$ -m abe
#$ -t 1-12
#$ -N step02_e_CRLF_markduplicates_files

# Version: v1
# Usage: qsub step02_e_CRLF_markduplicates_files.sh
# Description: Marks duplicate reads in aligned BAM 
# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Adapted by: Hanyu Yang (yhy020321@g.ucla.edu)
# Date: Oct 27 2024

## SETUP WORKSPACE  ##

sleep $((RANDOM % 120))

source /u/local/apps/anaconda3/2020.11/etc/profile.d/conda.sh
conda activate CRLF

set -xeo pipefail


## Define Variables 

HOMEDIR=/u/home/y/yhanyu/
WORKDIR=${HOMEDIR}/project-klohmuel/CRLF_raw_data/Preprocessing/${NAME}
mkdir -p "${WORKDIR}"
SEQDICT=${HOMEDIR}/project-klohmuel/CRLF_raw_data/20220331_CRLF_seq_metadata.txt
REF='Rmuscosa'

ROWID=$((SGE_TASK_ID + 1))
NAME=$(awk -v rowid=${ROWID} 'NR == rowid {print $1}' ${SEQDICT})

## Main

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Input = ${NAME} ${REF}; Starting markduplicates process"

cd "${WORKDIR}"
mkdir -p temp

# MarkDuplicates

picard -Xmx45G -Djava.io.tmpdir=./temp MarkDuplicates \
INPUT="${NAME}"_${REF}_MergeAligned.bam \
OUTPUT="${NAME}"_${REF}_MergeAligned_MarkDuplicates.bam \
METRICS_FILE="${NAME}"_${REF}_MarkDuplicates_metrics.txt \
MAX_RECORDS_IN_RAM=150000 MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 \
CREATE_INDEX=true \
TMP_DIR=./temp

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done"

## CLEANUP  ##

conda deactivate
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID} Done with MarkDuplicates"
