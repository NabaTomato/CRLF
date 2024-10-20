#! /bin/bash
#$ -l highp,h_rt=200:00:00,h_data=18G,h_vmem=36G
#$ -pe shared 2
#$ -wd <insert path to working directory>
#$ -o <insert log directory path>
#$ -e <insert log directory path>
#$ -m abe
#$ -t <change according to number of samples you can run simultaneously>
#$ -N step02_f_CAQU_Haplotypecaller_ExcludeList_filesXXtoXX

# Version: v1 - New version with data from 2024
# Usage: qsub step02_f_CAQU_Haplotypecaller_ExcludeList_20240422.sh
# Description: Generate haplotypes for CAQU resequencing data, included an interval exclude list of scaffolds that map to X chromosome
# Author: Meixi Lin (meixilin@ucla.edu)
# Adapted by: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON APR 22 2024

## Setup workspace

sleep $((RANDOM % 120))
source <insert path to miniconda>
conda activate my_gatk

set -o pipefail

## Define Variables ##
HOMEDIR=/u/home/1/1joeynik/project-rwayne/CAQU
WORKDIR=${HOMEDIR}/preprocessing/${NAME}
VCFDIR=${HOMEDIR}/preprocessing/VCFs/2024/HaplotypeCaller
mkdir -p ${WORKDIR}
mkdir -p ${VCFDIR}
SEQDICT2024=<insert path to sequence dictionary>
REFERENCE=<insert path to reference genome directory>
REF='GCA_023055505.1_bCalCai1.0.p'
EXCLUDELIST=<insert path to directory containing intervals that you want to exclude>

ROWID=$((SGE_TASK_ID + 1))
NAME=$(awk -v rowid=${ROWID} 'NR == rowid {print $1}' ${SEQDICT2024})
RGPU=$(awk -v rowid=${ROWID} 'NR == rowid {print $10}' ${SEQDICT2024})

## MAIN ##

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Input = Sample ${RGPU} and Reference ${REF}; Starting HaplotypeCaller"

cd ${WORKDIR}
mkdir -p temp

# Generate gVCF files

gatk3 -Xmx30G -Djava.io.tmpdir=./temp\ -XX:ParallelGCThreads=2 -T HaplotypeCaller \
-R ${REFERENCE} \
-ERC BP_RESOLUTION \
-mbq 20 \
-out_mode EMIT_ALL_SITES \
-XL ${EXCLUDELIST} \
-I ${HOMEDIR}/preprocessing/${NAME}/${RGPU}_${REF}_MergeAligned_MarkDuplicates.bam \
-o ${VCFDIR}/${RGPU}_${REF}_HaplotypeCaller.g.vcf.gz 

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" 
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done" 

## CLEANUP  ##

conda deactivate
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done with HaplotypeCaller"

