#! /bin/bash
#$ -l highp,h_rt=36:00:00,h_data=40G
#$ -wd /u/home/y/yhanyu/project-klohmuel/CRLF_raw_data       # Set working directory
#$ -o /u/home/y/yhanyu/project-klohmuel/logs/job_output.log  # output log
#$ -e /u/home/y/yhanyu/project-klohmuel/logs/job_error.log   # error log
#$ -m abe
#$ -M yhanyu
#$ -t 1-12
#$ -N step02_b_CRLF_FastqToSam_MarkAdapters

# Version: v1
# Usage: qsub step02_b_CRLF_FastqToSam_MarkAdapters.sh
# Description: Pipeline to process CRLF files before alignment
# Author: Hanyu Yang (yhy020321@g.ucla.edu)
# Date: Oct 27 2024

## SETUP WORKSPACE  ##

sleep $((RANDOM % 120))

source /u/local/apps/anaconda3/2020.11/etc/profile.d/conda.sh
conda activate CRLF

set -xeo pipefail

## Define Variables ##

HOMEDIR=/u/home/y/yhanyu/
WORKDIR=${HOMEDIR}/project-klohmuel/CRLF_raw_data/Preprocessing/${NAME}
SEQDICT=${HOMEDIR}/project-klohmuel/CRLF_raw_data/20220331_CRLF_seq_metadata.txt
mkdir -p "${WORKDIR}"

ROWID=$((SGE_TASK_ID + 1))
NAME=$(awk -v rowid=${ROWID} 'NR == rowid {print $1}' "${SEQDICT}") # for picard input: SAMPLE_NAME = Sample name to insert into the read group header Required.
FQ1=$(awk -v rowid=${ROWID} 'NR == rowid {print $2}' "${SEQDICT}") # forward read fastq.gz files, please use full path
FQ2=$(awk -v rowid=${ROWID} 'NR == rowid {print $3}' "${SEQDICT}") # reverse read fastq.gz files, please use full path
RGID=$(awk -v rowid=${ROWID} 'NR == rowid {print $4}' "${SEQDICT}") # for picard input: READ_GROUP_NAME = Read group name Default value: A.
RGLB=$(awk -v rowid=${ROWID} 'NR == rowid {print $5}' "${SEQDICT}") # for picard input: LIBRARY_NAME = The library name to place into the LB attribute in the read group header
RGPU=$(awk -v rowid=${ROWID} 'NR == rowid {print $6}' "${SEQDICT}") # for picard input: PLATFORM_UNIT = The platform unit (often run_barcode.lane) to insert into the read group header; {FLOWCELL_BARCODE}.{LANE}.{SAMPLE_NAME}
RGCN=$(awk -v rowid=${ROWID} 'NR == rowid {print $7}' "${SEQDICT}") # for picard input: SEQUENCING_CENTER = The sequencing center from which the data originated
RGPM=$(awk -v rowid=${ROWID} 'NR == rowid {print $8}' "${SEQDICT}") # for picard input: PLATFORM_MODEL = "NovaSeq/HiSeq"

## MAIN 

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Input = ${FQ1} ${FQ2} ${NAME} ${RGID} ${RGLB} ${RGPU} ${RGCN} ${RGPM} ${FLAG} ${REF}; Starting preprocessing fastq before alignment"

cd "${WORKDIR}"
mkdir -p temp

# FastqToSam

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Picard FastqToSam..." 

picard -Xmx20G FastqToSam \
FASTQ="${SEQDIR}"/"${FQ1}" \
FASTQ2="${SEQDIR}"/"${FQ2}" \
OUTPUT="${NAME}"_FastqToSam.bam \
READ_GROUP_NAME="${RGID}" \
SAMPLE_NAME="${NAME}" \
LIBRARY_NAME="${RGLB}" \
PLATFORM_UNIT="${RGPU}" \
SEQUENCING_CENTER="${RGCN}" \
PLATFORM_MODEL="${RGPM}" \
PLATFORM=illumina \
TMP_DIR=./temp 

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with Picard FastqToSam..."

# MarkAdapters

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Picard MarkAdapters... "

picard -Xmx20G MarkIlluminaAdapters \
INPUT="${NAME}"_FastqToSam.bam \
OUTPUT="${NAME}"_MarkAdapters.bam \
METRICS=02_b_CRLF_"${NAME}"_MarkAdapters_metrics.txt \
TMP_DIR=./temp 

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" 
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with Picard MarkAdapters... "

# AlignCleanBam

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Prepare for aligning: Picard SamToFastq... " 

picard -Xmx20G SamToFastq \
INPUT="${NAME}"_MarkAdapters.bam \
FASTQ="${NAME}"_MarkAdapters.fastq \
CLIPPING_ATTRIBUTE=XT CLIPPING_ACTION=2 INTERLEAVE=true NON_PF=true \
TMP_DIR=./temp

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with Picard SamToFastq..."  

## Clean up

conda deactivate
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done with preprocessing fastq before alignment"
