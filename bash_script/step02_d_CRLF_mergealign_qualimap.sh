#! /bin/bash
#$ -l highp,h_rt=80:00:00,h_data=60G
#$ -wd /u/home/y/yhanyu/project-klohmuel/CRLF_raw_data       # Set working directory
#$ -o /u/home/y/yhanyu/project-klohmuel/logs/job_output.log  # output log
#$ -e /u/home/y/yhanyu/project-klohmuel/logs/job_error.log   # error log
#$ -m abe
#$ -N step02_d_CRLF_mergealign_qualimap
#$ -t 1-12

# Version: v1
# Usage: qsub step02_d_CRLF_mergealign_qualimap.sh
# Description: merge unmapped and mapped BAM, check quality of alignment using Qualimap
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
mkdir -p "${WORKDIR}"
SEQDICT=${HOMEDIR}/project-klohmuel/CRLF_raw_data/20220331_CRLF_seq_metadata.txt
REF='Rmuscosa'
REFERENCE=/${HOMEDIR}/project-klohmuel/ref_genome/GCA_029206835.1_Rmu.v1_genomic.fasta

ROWID=$((SGE_TASK_ID + 1))
NAME=$(awk -v rowid=${ROWID} 'NR == rowid {print $1}' ${SEQDICT})

## Main

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Input = ${NAME} ${REF}; Starting merging BAM files and qualimap"

cd "${WORKDIR}"
mkdir -p temp

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID} Merge Bam..."

# merge bam alignment

picard -Xmx50G MergeBamAlignment \
ALIGNED_BAM="${NAME}"_${REF}_BWA_Aligned.bam \
UNMAPPED_BAM="${NAME}"_FastqToSam.bam \
OUTPUT="${NAME}"_${REF}_MergeAligned.bam \
R=${REFERENCE} CREATE_INDEX=false \
ADD_MATE_CIGAR=true CLIP_ADAPTERS=false CLIP_OVERLAPPING_READS=true \
INCLUDE_SECONDARY_ALIGNMENTS=true MAX_INSERTIONS_OR_DELETIONS=-1 \
PRIMARY_ALIGNMENT_STRATEGY=MostDistant ATTRIBUTES_TO_RETAIN=XS \
TMP_DIR=./temp

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done"

# Run qualimap on aligned bam

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}  Qualimap... "

qualimap bamqc -bam "${RGPU}"_${REF}_MergeAligned.bam -outdir "${WORKDIR}" -c --java-mem-size=50G

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done"

## Cleanup

conda deactivate
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID} Done merging BAM files and running qualimap"
