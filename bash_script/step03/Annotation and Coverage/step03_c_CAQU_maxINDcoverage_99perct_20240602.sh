#!/bin/bash
#$ -l highp,h_rt=8:00:00,h_data=20G,h_vmem=20G
#$ -pe shared 1
#$ -N step03_c_CAQU_maxINDcoverage_99perct_MVZCCGPsamples
#$ -m bea
#$ -o <insert log directory path>
#$ -e <insert log directory path>
#$ -M 1joeynik

# Version: V2 - adding in 2024 samples from MVZ, NHMLA, and WFVZ
# Usage: qsub step03_c_CAQU_maxINDcoverage_99perct_20240602.sh
# Description: cat the files produced by step03_d_CAQU_getINDcoverage.sh in order to get the max coverage for each individual CAQU
# Author: Chris Kyriazis
# Adapted by: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON JUN 02 2024

## Setup workspace

source /u/home/1/1joeynik/project-rwayne/software/miniconda3/etc/profile.d/conda.sh
conda activate my_datamash

set -o pipefail

## Define Variables

source /u/home/1/1joeynik/project-rwayne/CAQU/scripts/step03_genotyping/step03_CAQU_WGSvars.txt

WORKDIR=/u/home/1/1joeynik/project-rwayne/CAQU/stats/getINDcoverage
OUTDIR=${WORKDIR}/cat
FILES=${OUTDIR}/CombinedCoverage_MVZCCGP*.txt
mkdir -p ${OUTDIR}

## Main

cd ${WORKDIR}

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Starting for loop to cat coverage values to find max(IND level coverage)"

for i in "${Inds2[@]}"
do
        echo ${i}
        cat ${i}* >> ${OUTDIR}/'CombinedCoverage_'${i}'.txt'
done

for i in ${FILES}
do
	echo -e "${i},$(datamash perc:99 1 < $i)"
done >> ${OUTDIR}/CombinedCoverage_AllInds_99perct_20240610.txt

## Cleanup

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; done getting individual depth 99th percentile values"
conda deactivate

