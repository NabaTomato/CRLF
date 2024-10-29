#! /bin/bash
#$ -l highp,h_rt=120:00:00,h_data=20G,h_vmem=60G
#$ -pe shared 3
#$ -wd <insert path to working directory>
#$ -o <insert path to log directory>
#$ -e <insert path to log directory>
#$ -m abe
#$ -N step03_c_CAQU_VariantFiltration
#$ -t <adjust according to how many scaffolds you can run simultaneously>

# Version: V2 - Adding in samples from  MVZ, and WFVZ
# Usage: qsub step03_c_CRLF_VariantFiltration.sh
# Description: Hard quaility filtering for CAQU samples
# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON JUN 10 2024
# Note: need to have python package 'vcf' downloaded and in the working directory for this script to work

## Setup workspace

sleep $((RANDOM % 120))
source <insert path to miniconda>
conda activate my_gatk

set -o pipefail

## Define Variables

WORKDIR=<insert path for output directory from previous script>
OUTDIR1=<insert path for output directory for intermediate VCF from this script>
OUTDIR2=<insert path for output directory for filtered VCF>
mkdir -p ${OUTDIR1}
mkdir -p ${OUTDIR2}
REFERENCE=<insert path to reference sequence directory>
FILTERSCRIPT2024=<insert path to custom python filtering script that comes after this script>

## Main

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Starting GATK VariantFiltration and custom filter script"

cd ${WORKDIR}
mkdir -p temp

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID} GATK VariantFiltration..."

# VariantFiltration

gatk3 -Xmx15G -Djava.io.tmpdir=./temp -T VariantFiltration \
-R ${REFERENCE} \
--logging_level ERROR \
--mask ${MASK} --maskName "FAIL_Rep" \
-filter "QUAL < 30.0" --filterName "FAIL_qual" \
-filter "DP >1495" --filterName "FAIL_DP" \
-L ${BED} \
-V ${WORKDIR}/${REF}_INT${SGE_TASK_ID}_VariantAnnotator.vcf.gz \
-o ${OUTDIR1}/${REF}_INT${SGE_TASK_ID}_VariantFiltration.vcf.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with VariantFiltration"

# Custom site-level python filtering step

source <insert path to miniconda>
conda activate my_tabix

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID} Now onto custom genotype level filtering with python script..."

python ${FILTERSCRIPT2024} ${OUTDIR1}/${REF}_INT${SGE_TASK_ID}_VariantFiltration.vcf.gz | bgzip > ${OUTDIR2}/${REF}_INT${SGE_TASK_ID}_CustomPyFilter.vcf.gz
tabix -p vcf ${OUTDIR2}/${REF}_INT${SGE_TASK_ID}_CustomPyFilter.vcf.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with custom python filter"

## Cleanup

echo "[$(date "+%Y-%m-%d %T")] Job ID: ${JOB_ID}.${SGE_TASK_ID}; Done filtering VCF"

conda deactivate
