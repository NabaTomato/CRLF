#! /bin/bash
#$ -l highp,h_rt=36:00:00,h_data=40G
#$ -wd <insert working directory path>
#$ -o <insert log directory path>
#$ -e <insert log directory path>
#$ -m abe
#$ -M 1joeynik
#$ -t <change according to how many files you are running at a time>
#$ -N step02_b_CAQU_FastqToSam_MarkAdapters_filesXXtoXX

# Version: v2 - updated to run on new CAQU sequences from 2024
# Usage: qsub step02_b_CAQU_FastqToSam_MarkAdapters_20240415.sh
# Description: Pipeline to process CAQU files before alignment
# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON APR 15 2024

## SETUP WORKSPACE  ##

sleep $((RANDOM % 120))
source <insert path to miniconda>
conda activate my_picard 

set -o pipefail

## Define Variables ##

SEQDICT2024=<insert path for sequence dictionary>
WORKDIR=${HOMEDIR}/preprocessing/${NAME}
mkdir -p ${WORKDIR}

ROWID=$((SGE_TASK_ID + 1))
FQ1=$(awk -v rowid=${ROWID} 'NR == rowid {print $2}' ${SEQDICT2024}) # forward read fastq.gz files, please use full path
FQ2=$(awk -v rowid=${ROWID} 'NR == rowid {print $3}' ${SEQDICT2024}) # reverse read fastq.gz files, please use full path
NAME=$(awk -v rowid=${ROWID} 'NR == rowid {print $1}' ${SEQDICT2024}) # for picard input: SAMPLE_NAME = Sample name to insert into the read group header Required.
RGID=$(awk -v rowid=${ROWID} 'NR == rowid {print $8}' ${SEQDICT2024}) # for picard input: READ_GROUP_NAME = Read group name Default value: A.
RGLB=$(awk -v rowid=${ROWID} 'NR == rowid {print $9}' ${SEQDICT2024}) # for picard input: LIBRARY_NAME = The library name to place into the LB attribute in the read group header
RGPU=$(awk -v rowid=${ROWID} 'NR == rowid {print $10}' ${SEQDICT2024}) # for picard input: PLATFORM_UNIT = The platform unit (often run_barcode.lane) to insert into the read group header; {FLOWCELL_BARCODE}.{LANE}.{SAMPLE_NAME}
RGCN=$(awk -v rowid=${ROWID} 'NR == rowid {print $11}' ${SEQDICT2024}) # for picard input: SEQUENCING_CENTER = The sequencing center from which the data originated
RGPM=$(awk -v rowid=${ROWID} 'NR == rowid {print $12}' ${SEQDICT2024}) # for picard input: PLATFORM_MODEL = "NovaSeq/HiSeq"

## MAIN 

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Input = ${FQ1} ${FQ2} ${NAME} ${RGID} ${RGLB} ${RGPU} ${RGCN} ${RGPM} ${FLAG} ${REF}; Starting preprocessing fastq before alignment"

cd ${WORKDIR}
mkdir -p temp

# FastqToSam

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Picard FastqToSam..." 

picard -Xmx20G FastqToSam \
FASTQ=${SEQDIR2024}/${FQ1} \
FASTQ2=${SEQDIR2024}/${FQ2} \
OUTPUT=${RGPU}_FastqToSam.bam \
READ_GROUP_NAME=${RGID} \
SAMPLE_NAME=${NAME} \
LIBRARY_NAME=${RGLB} \
PLATFORM_UNIT=${RGPU} \
SEQUENCING_CENTER=${RGCN} \
PLATFORM_MODEL=${RGPM} \
PLATFORM=illumina \
TMP_DIR=./temp 

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with Picard FastqToSam..."

# MarkIlluminaAdapters

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Picard MarkIlluminaAdapters... " 

picard -Xmx20G MarkIlluminaAdapters \
INPUT=${RGPU}_FastqToSam.bam \
OUTPUT=${RGPU}_MarkIlluminaAdapters.bam \
METRICS=02_b_CAQU_${RGPU}_MarkIlluminaAdapters_metrics.txt \
TMP_DIR=./temp 

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" 
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with Picard MarkIlluminaAdapters... "

# AlignCleanBam

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Prepare for aligning: Picard SamToFastq... " 

picard -Xmx20G SamToFastq \
INPUT=${RGPU}_MarkIlluminaAdapters.bam \
FASTQ=${RGPU}_MarkIlluminaAdapters.fastq \
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
