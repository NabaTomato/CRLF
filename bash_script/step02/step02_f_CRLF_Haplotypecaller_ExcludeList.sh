#! /bin/bash
#$ -l highp,h_rt=200:00:00,h_data=18G,h_vmem=36G
#$ -pe shared 2
#$ -wd /u/home/y/yhanyu/project-klohmuel/CRLF_raw_data       # Set working directory
#$ -o /u/home/y/yhanyu/project-klohmuel/logs/job_output.log  # output log
#$ -e /u/home/y/yhanyu/project-klohmuel/logs/job_error.log   # error log
#$ -m abe
#$ -t 1-12
#$ -N step02_f_CRLF_Haplotypecaller_ExcludeList

# Version: v1
# Usage: qsub step02_f_CRLF_Haplotypecaller_ExcludeList.sh
# Description: Generate haplotypes for CRLF resequencing data, included an interval exclude list of scaffolds that map to X chromosome
# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Adapted by: Hanyu Yang (yhy020321@g.ucla.edu)
# Date: Oct 27 2024

## Setup workspace

sleep $((RANDOM % 120))

source /u/local/apps/anaconda3/2020.11/etc/profile.d/conda.sh
conda activate CRLF

set -xeo pipefail

## Define Variables ##
HOMEDIR=/u/home/y/yhanyu/
WORKDIR=${HOMEDIR}/project-klohmuel/CRLF_raw_data/Preprocessing/${NAME}
VCFDIR=${HOMEDIR}/project-klohmuel/CRLF_raw_data/Preprocessing/VCFs/HaplotypeCaller
mkdir -p ${WORKDIR}
mkdir -p ${VCFDIR}
SEQDICT=${HOMEDIR}/project-klohmuel/CRLF_raw_data/20220331_CRLF_seq_metadata.txt
REF='Rmuscosa'
REFERENCE=/${HOMEDIR}/project-klohmuel/ref_genome/GCA_029206835.1_Rmu.v1_genomic.fasta
EXCLUDELIST=<insert path to directory containing intervals that you want to exclude>

ROWID=$((SGE_TASK_ID + 1))
NAME=$(awk -v rowid=${ROWID} 'NR == rowid {print $1}' ${SEQDICT})

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
-I ${HOMEDIR}/preprocessing/${NAME}/${NAME}_${REF}_MergeAligned_MarkDuplicates.bam \
-o ${VCFDIR}/${NAME}_${REF}_HaplotypeCaller.g.vcf.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL" 
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done" 

## CLEANUP  ##

conda deactivate
echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID} Done with HaplotypeCaller"

