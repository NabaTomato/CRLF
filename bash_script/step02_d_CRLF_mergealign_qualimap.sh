#! /bin/bash
#$ -l highp,h_rt=80:00:00,h_data=60G
#$ -wd <insert working directory path>
#$ -o <insert log directory path>
#$ -e <insert log directory path>
#$ -m abe
#$ -N step02_d_CAQU_mergealign_qualimap_filesXXtoXX
#$ -t <change according to the number of samples you can run simultaneously>

# Version: v2 - editing to run on 2024 samples
# Usage: qsub step02_d_CRLF_mergealign_qualimap.sh
# Description: merge unmapped and mapped BAM, check quality of alignment using Qualimap
# Author: Joey Curti (jcurti3@g.ucla.edu)
# Date: THU APR 18 2024 

## Setup workspace

sleep $((RANDOM % 120))
source <insert path to miniconda>
conda activate my_picard

set -o pipefail

## Define variables

WORKDIR=${HOMEDIR}/preprocessing/${NAME}
mkdir -p ${WORKDIR}
SEQDICT2024=<insert path to sequence dictionary>
REF='GCA_023055505.1_bCalCai1.0.p'
REFERENCE=<insert path to reference sequence directory>

ROWID=$((SGE_TASK_ID + 1))
NAME=$(awk -v rowid=${ROWID} 'NR == rowid {print $1}' ${SEQDICT2024})
RGPU=$(awk -v rowid=${ROWID} 'NR == rowid {print $10}' ${SEQDICT2024})

## Main

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}; Input = ${RGPU} ${REF}; Starting merging BAM files and qualimap"

cd ${WORKDIR}
mkdir -p temp

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID} Merge Bam..."

# merge bam alignment

picard -Xmx50G MergeBamAlignment \
ALIGNED_BAM=${RGPU}_${REF}_BWA_Aligned.bam \
UNMAPPED_BAM=${RGPU}_FastqToSam.bam \
OUTPUT=${RGPU}_${REF}_MergeAligned.bam \
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

conda activate my_qualimap

qualimap bamqc -bam ${RGPU}_${REF}_MergeAligned.bam -outdir ${WORKDIR} -c --java-mem-size=50G

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done"

## Cleanup

conda deactivate
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID} Done merging BAM files and running qualimap"
