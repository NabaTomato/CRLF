#! /bin/bash
#$ -l highp,h_rt=120:00:00,h_data=20G,h_vmem=60G
#$ -pe shared 3
#$ -wd <insert working directory path>
#$ -o <insert log directory path>
#$ -e <insert log directory path>
#$ -m abe
#$ -N step03_a_CAQU_GenotypeGVCF_ExcludeList
#$ -t <change this to reflect the number of scaffolds that can be run simultaneously>

# Version: v2 - Revising to include samples from MVZ and museums
# Usage: qsub step03_a_CRLF_GenotypeGVCF_ExcludeList.sh
# Description: Joint genotyping on all 62 CAQU samples
# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Date: THU MAY 30 2024

## SETUP WORKSPACE

sleep $((RANDOM % 120))
source <insert path to miniconda>
conda activate my_gatk

set -o pipefail

## Define Variables

BED=<insert path to intervals directory>

# Working directories

WORKDIR=<insert path to gVCFs from HaplotypeCaller output>
VCFDIR=<insert output directory>
mkdir -p ${VCFDIR}
REFERENCE=<insert path to reference sequence>

## MAIN

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Starting joint genotyping using GATK GenotypeGVCFs..."

cd ${WORKDIR}
mkdir -p temp

# GenotypeGVCF

gatk3 -Xmx30G -Djava.io.tmpdir=./temp -T GenotypeGVCFs \
-R ${REFERENCE} \
-allSites \
-stand_call_conf 0 \
-L ${BED} \
$(for Individual in "${Inds[@]}"; do echo "-V /u/home/1/1joeynik/project-rwayne/CAQU/preprocessing/VCFs/2024/HaplotypeCaller/*${Individual}_${REF}_HaplotypeCaller.g.vcf.gz"; done) \
-o ${WORKDIR}/VCFs/2024/GenotypeGVCF/${REF}_INT${SGE_TASK_ID}_GenotypeGVCF.vcf.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done"

## Cleanup

echo "[$(date "+%Y-%m-%d %T")] Job ID: ${JOB_ID}.${SGE_TASK_ID}; Done with join genotyping using GATK GenotypeGVCFs"
conda deactivate

