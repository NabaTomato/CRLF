#! /bin/bash
#$ -l highp,h_rt=120:00:00,h_data=20G,h_vmem=60G
#$ -pe shared 3
#$ -wd <insert working directory path>
#$ -o <insert log directory path>
#$ -e <insert log directory path>
#$ -m abe
#$ -N step03_b_CAQU_TrimAlternates_VariantAnnotator_ExludeList
#$ -t <change according to how many scaffolds can be run simultaneously>

# Version: v2 - including additional samples from MVZ and NHMLA/WFVZ
# Usage: qsub step03_b_CAQU_TrimAlternates_VariantAnnotator_ExcludeList_20240531.sh
# Description: Trimming alternate alleles and annotating variant type, excludes scaffolds that align to the chicken Z chromosome
# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON JUN 02 2024

## Setup workspace

sleep $((RANDOM % 120))
source <insert path to miniconda>
conda activate my_gatk

set -o pipefail

## Define Variables

BED=<insert path to intervals directory>

# Working directories

WORKDIR=<insert path to working directory>
REFERENCE=<insert path to reference sequence directory>

## Main

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Starting GATK TrimAlternates and VariantAnnotator"

cd ${WORKDIR}
mkdir -p temp
mkdir -p ${WORKDIR}/TrimAlternates # output directory for intermediate file resulting from TrimAlternates call
mkdir -p ${WORKDIR}/VariantAnnotator # output directory for intermediate file resulting from VariantAnnotator call

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID} GATK TrimAlternates"

# TrimAlternates

gatk3 -Xmx30G -Djava.io.tmpdir=./temp -T SelectVariants \
-R ${REFERENCE} \
-trimAlternates \
-L ${BED} \
-V ${WORKDIR}/GenotypeGVCF/${REF}_INT${SGE_TASK_ID}_GenotypeGVCF.vcf.gz \
-o ${WORKDIR}/TrimAlternates/${REF}_INT${SGE_TASK_ID}_TrimAlternates.vcf.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with TrimAlternates"

# VariantAnnotator

gatk3 -Xmx30G -Djava.io.tmpdir=./temp -T VariantAnnotator \
-R ${REFERENCE} \
-G StandardAnnotation \
-A VariantType \
-A AlleleBalance \
-L ${BED} \
-V ${WORKDIR}/TrimAlternates/${REF}_INT${SGE_TASK_ID}_TrimAlternates.vcf.gz \
-o ${WORKDIR}/VariantAnnotator/${REF}_INT${SGE_TASK_ID}_VariantAnnotator.vcf.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with VariantAnnotator"

## Cleanup

echo "[$(date "+%Y-%m-%d %T")] Job ID: ${JOB_ID}.${SGE_TASK_ID}; Done with GATK TrimAlternates and VariantAnnotator"
conda deactivate
