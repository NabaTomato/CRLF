#!/bin/bash
#$ -l highp,h_rt=24:00:00,h_data=10G,h_vmem=60G
#$ -pe shared 6
#$ -N step03_a_CAQU_getCombDP
#$ -m bea
#$ -o <insert log directory path>
#$ -e <insert log directory path>
#$ -M 1joeynik
#$ -t <change according to how many scaffolds you can run simultaneously>

# Version: V2 - adding in new 2024 samples from MVZ, NHMLA, and WFVZ
# Usage: qsub step03_a_CRLF_getCombDP.sh
# Description: Use this to get annotations in VCF file in order to calculate DP cutoff for hard filtering
# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON JUN 02 2024

## SETUP WORKSPACE  ##

sleep $((RANDOM % 120))
source <insert path to miniconda>
conda activate my_gatk

set -o pipefail

## Define Variables ##

OUTDIR=<insert output directory>
WORKDIR=<insert path to VCF that has gone through joint genotyping and VariantAnnotator>
mkdir -p ${OUTDIR}
REFERENCE=<insert path to reference sequence directory>
REF='GCA_023055505.1_bCalCai1.0.p'

## MAIN ##

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Starting GATK SelectVariants and VariantsToTable"

# SelectVariants

gatk3 -Xmx15G -Djava.io.tmpdir=./temp -T SelectVariants \
-R ${REFERENCE} \
-V ${WORKDIR}/${REF}_INT${SGE_TASK_ID}_VariantAnnotator.vcf.gz \
-selectType SNP \
-o ${OUTDIR}/${REF}_INT${SGE_TASK_ID}_snps.vcf

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo "[$(date "+%Y-%m-%d %T")] Job ID: ${JOB_ID}.${SGE_TASK_ID}; Done with SelectVariants"

# Get Annotations with VariantsToTable

gatk3 -Xmx15G -Djava.io.tmpdir=./temp -T VariantsToTable \
-R ${REFERENCE} \
-V ${OUTDIR}/${REF}_INT${SGE_TASK_ID}_snps.vcf \
-F AN \
-F BaseQRankSum \
-F DP \
-F FS \
-F MQ \
-F MQRankSum \
-F QD \
-F ReadPosRankSum \
-F SOR \
--out ${OUTDIR}/${REF}_INT${SGE_TASK_ID}_snps_table.txt

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo "[$(date "+%Y-%m-%d %T")] Job ID: ${JOB_ID}.${SGE_TASK_ID}; Done with VariantsToTable"

## CLEANUP  ##

echo "[$(date "+%Y-%m-%d %T")] Job ID: ${JOB_ID}.${SGE_TASK_ID}; Done with GATK SelectVariants and VariantsToTable"
conda deactivate
