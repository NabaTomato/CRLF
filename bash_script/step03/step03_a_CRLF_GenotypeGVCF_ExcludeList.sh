#! /bin/bash
#$ -l highp,h_rt=120:00:00,h_data=20G,h_vmem=60G
#$ -pe shared 3
#$ -wd /u/home/y/yhanyu/project-klohmuel/CRLF_raw_data       # Set working directory
#$ -o /u/home/y/yhanyu/project-klohmuel/logs/job_output.log  # output log
#$ -e /u/home/y/yhanyu/project-klohmuel/logs/job_error.log   # error log
#$ -m abe
#$ -N step03_a_CRLF_GenotypeGVCF_ExcludeList
#$ -t <change this to reflect the number of scaffolds that can be run simultaneously>

# Version: v2 - Revising to include samples from MVZ and museums
# Usage: qsub step03_a_CRLF_GenotypeGVCF_ExcludeList.sh
# Description: Joint genotyping on all 62 CRLF samples
# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Adapted by: Hanyu Yang (yhy020321@g.ucla.edu)
# Date: Oct 27 2024

## SETUP WORKSPACE

sleep $((RANDOM % 120))

source /u/local/apps/anaconda3/2020.11/etc/profile.d/conda.sh
conda activate CRLF

set -xeo pipefail

## Define Variables

BED=<insert path to intervals directory>

# Working directories

HOMEDIR=/u/home/y/yhanyu/
WORKDIR=${HOMEDIR}/project-klohmuel/CRLF_raw_data/Preprocessing/${NAME}
VCFDIR=${HOMEDIR}/project-klohmuel/CRLF_raw_data/Preprocessing/VCFs/HaplotypeCaller
mkdir -p ${WORKDIR}
mkdir -p ${VCFDIR}
REFERENCE=/${HOMEDIR}/project-klohmuel/ref_genome/GCA_029206835.1_Rmu.v1_genomic.fasta

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

