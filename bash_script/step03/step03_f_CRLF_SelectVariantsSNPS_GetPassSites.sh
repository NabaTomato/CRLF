#! /bin/bash
#$ -l highp,h_rt=100:00:00,h_data=12G,h_vmem=48G
#$ -pe shared 4
#$ -wd <insert path to working directory>
#$ -o <insert path to log directory>
#$ -e <insert path to log directory>
#$ -N step03_f_CAQU_SelectVariantsSNPS_GetPassSites

# Version: v2 - adding samples from MVZ, NHMLA, and WFVZ
# Usage: qsub step03_f_CRLF_SelectVariantsSNPS_GetPassSites.sh
# Description: Select SNPs from combined/filtered gVCF then select sites that passed site and genotype-level filters
# Adapted By: Joseph Curti (jcurti3@g.ucla.edu)
# Author: Chris Kyriazis
# Date: FRI JUN 14 2024

## SETUP WORKSPACE  ##

sleep $((RANDOM % 120))
source <insert path to miniconda>
conda activate my_gatk

set -o pipefail

## Define Variables

INDIR=<insert path to output merged vcf from previous step>
OUTDIR=<insert path to output directory>
mkdir -p ${OUTDIR}
REFERENCE=<insert path to reference sequence directory>

## Main

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Selecting Biallelic SNPs with GATK SelectVariants and then grep selecting Pass sites..."
cd ${INDIR}

# SelectVariants - Biallelic SNPs

gatk3 -Xmx15G -Djava.io.tmpdir=./temp -T SelectVariants \
-R ${REFERENCE} \
--restrictAllelesTo BIALLELIC \
--selectTypeToInclude SNP \
-V ${INDIR}/GCA_023055505.1_bCalCai1.0.p_MergedScaffolds.vcf.gz \
-o ${OUTDIR}/GCA_023055505.1_bCalCai1.0.p_AllBiallelicSNPs.vcf.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with SelectVariants"

# Grep Pass Sites

conda activate my_tabix

zgrep -e "PASS" -e "#" ${OUTDIR}/GCA_023055505.1_bCalCai1.0.p_AllBiallelicSNPs.vcf.gz | bgzip > ${OUTDIR}/GCA_023055505.1_bCalCai1.0.p_PassSNPs.vcf.gz

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done selecting pass sites"

## Cleanup

echo "[$(date "+%Y-%m-%d %T")] Job ID: ${JOB_ID}.${SGE_TASK_ID}; Done Selecting Biallelic SNPs with GATK SelectVariants and then grepping Pass sites"
conda deactivate