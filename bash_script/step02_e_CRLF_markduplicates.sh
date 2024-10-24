#! /bin/bash
#$ -l highp,h_rt=120:00:00,h_data=8G,h_vmem=64G
#$ -pe shared 8
#$ -wd <insert path to working directory>
#$ -o <insert path to log directory>
#$ -e <insert path to log directory>
#$ -m abe
#$ -t <change according to how many samples you can run simultaneously>
#$ -N step02_e_CAQU_markduplicates_filesXXtoXX

# Version: v2 - adapting for new sequencing data in 2024
# Usage: qsub step02_e_CRLF_markduplicates.sh
# Description: Marks duplicate reads in aligned BAM 
# Author: Meixi Lin (meixilin@ucla.edu)
# Adapted by: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON APR 22 2024

## SETUP WORKSPACE  ##

sleep $((RANDOM % 120))
source <insert path to miniconda>
conda activate my_picard

set -o pipefail

## Define Variables 

WORKDIR=${HOMEDIR}/preprocessing/${NAME}
mkdir -p ${WORKDIR}
SEQDICT2024=<insert path to sequence dictionary>
REF='GCA_023055505.1_bCalCai1.0.p'

ROWID=$((SGE_TASK_ID + 1))
NAME=$(awk -v rowid=${ROWID} 'NR == rowid {print $1}' ${SEQDICT2024})
RGPU=$(awk -v rowid=${ROWID} 'NR == rowid {print $10}' ${SEQDICT2024})

## Main

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Input = ${RDPU} ${REF}; Starting markduplicates process"

cd ${WORKDIR}
mkdir -p temp

# MarkDuplicates

picard -Xmx45G -Djava.io.tmpdir=./temp MarkDuplicates \
INPUT=${RGPU}_${REF}_MergeAligned.bam \
OUTPUT=${RGPU}_${REF}_MergeAligned_MarkDuplicates.bam \
METRICS_FILE=${RGPU}_${REF}_MarkDuplicates_metrics.txt \
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
