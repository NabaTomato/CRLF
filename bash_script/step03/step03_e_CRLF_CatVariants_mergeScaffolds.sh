#! /bin/bash
#$ -l highp,h_rt=100:00:00,h_data=12G,h_vmem=48G
#$ -pe shared 4
#$ -wd <insert path to working directory>
#$ -o <insert path to log directory>
#$ -e <insert path to log directory>
#$ -m abe
#$ -N step03_e_CAQU_CatVariants_mergeScaffolds

# Version: v2 - adding samples from MVZ, NHMLA, and WFVZ
# Usage: qsub step03_e_CRLF_CatVariants_mergeScaffolds.sh
# Description: Concatenate all of the individual scaffold VCF files into one file
# Adapted By: Joseph Curti (jcurti3@g.ucla.edu)
# Author: Chris Kyriazis
# Date: THU JUN 13 2024

## SETUP WORKSPACE  ##

sleep $((RANDOM % 120))
set -o pipefail

## Define Variables

INDIR=<insert path to output directory from custom python filtering script>
OUTDIR=<insert output directory>
mkdir -p ${OUTDIR}
prefix='GCA_023055505.1_bCalCai1.0.p_'
suffix='_CustomPyFilter.vcf.gz'
GATK=<insert path to GATK>

## Main

echo -e "[$(date "+%Y-%m-%d %T")] JOB ID ${JOB_ID}.${SGE_TASK_ID}; Combining VCF files with CatVariants..."

# CatVariants
java -cp ${GATK} org.broadinstitute.gatk.tools.CatVariants \
-R ${REFERENCE} \
-V ${INDIR}/${prefix}INT1${suffix} \
-V ${INDIR}/${prefix}INT2${suffix} \
-V ${INDIR}/${prefix}INT3${suffix} \
-V ${INDIR}/${prefix}INT4${suffix} \
-V ${INDIR}/${prefix}INT5${suffix} \
-V ${INDIR}/${prefix}INT6${suffix} \
-V ${INDIR}/${prefix}INT7${suffix} \
-V ${INDIR}/${prefix}INT8${suffix} \
-V ${INDIR}/${prefix}INT10${suffix} \
-V ${INDIR}/${prefix}INT11${suffix} \
-V ${INDIR}/${prefix}INT12${suffix} \
-V ${INDIR}/${prefix}INT13${suffix} \
-V ${INDIR}/${prefix}INT14${suffix} \
-V ${INDIR}/${prefix}INT15${suffix} \
-V ${INDIR}/${prefix}INT16${suffix} \
-V ${INDIR}/${prefix}INT17${suffix} \
-V ${INDIR}/${prefix}INT18${suffix} \
-V ${INDIR}/${prefix}INT19${suffix} \
-V ${INDIR}/${prefix}INT20${suffix} \
-V ${INDIR}/${prefix}INT21${suffix} \
-V ${INDIR}/${prefix}INT22${suffix} \
-V ${INDIR}/${prefix}INT24${suffix} \
-V ${INDIR}/${prefix}INT26${suffix} \
-V ${INDIR}/${prefix}INT27${suffix} \
-V ${INDIR}/${prefix}INT28${suffix} \
-V ${INDIR}/${prefix}INT29${suffix} \
-V ${INDIR}/${prefix}INT30${suffix} \
-V ${INDIR}/${prefix}INT32${suffix} \
-V ${INDIR}/${prefix}INT33${suffix} \
-V ${INDIR}/${prefix}INT34${suffix} \
-V ${INDIR}/${prefix}INT35${suffix} \
-V ${INDIR}/${prefix}INT36${suffix} \
-V ${INDIR}/${prefix}INT37${suffix} \
-V ${INDIR}/${prefix}INT38${suffix} \
-V ${INDIR}/${prefix}INT39${suffix} \
-V ${INDIR}/${prefix}INT40${suffix} \
-V ${INDIR}/${prefix}INT42${suffix} \
-V ${INDIR}/${prefix}INT43${suffix} \
-V ${INDIR}/${prefix}INT44${suffix} \
-V ${INDIR}/${prefix}INT45${suffix} \
-V ${INDIR}/${prefix}INT46${suffix} \
-V ${INDIR}/${prefix}INT47${suffix} \
-V ${INDIR}/${prefix}INT48${suffix} \
-V ${INDIR}/${prefix}INT50${suffix} \
-V ${INDIR}/${prefix}INT51${suffix} \
-V ${INDIR}/${prefix}INT53${suffix} \
-V ${INDIR}/${prefix}INT54${suffix} \
-V ${INDIR}/${prefix}INT55${suffix} \
-V ${INDIR}/${prefix}INT56${suffix} \
-V ${INDIR}/${prefix}INT57${suffix} \
-V ${INDIR}/${prefix}INT58${suffix} \
-V ${INDIR}/${prefix}INT59${suffix} \
-V ${INDIR}/${prefix}INT60${suffix} \
-V ${INDIR}/${prefix}INT61${suffix} \
-V ${INDIR}/${prefix}INT63${suffix} \
-V ${INDIR}/${prefix}INT64${suffix} \
-V ${INDIR}/${prefix}INT65${suffix} \
-V ${INDIR}/${prefix}INT67${suffix} \
-V ${INDIR}/${prefix}INT68${suffix} \
-V ${INDIR}/${prefix}INT69${suffix} \
-V ${INDIR}/${prefix}INT70${suffix} \
-V ${INDIR}/${prefix}INT71${suffix} \
-V ${INDIR}/${prefix}INT72${suffix} \
-V ${INDIR}/${prefix}INT73${suffix} \
-V ${INDIR}/${prefix}INT74${suffix} \
-V ${INDIR}/${prefix}INT75${suffix} \
-V ${INDIR}/${prefix}INT76${suffix} \
-V ${INDIR}/${prefix}INT77${suffix} \
-V ${INDIR}/${prefix}INT78${suffix} \
-V ${INDIR}/${prefix}INT79${suffix} \
-V ${INDIR}/${prefix}INT80${suffix} \
-V ${INDIR}/${prefix}INT81${suffix} \
-V ${INDIR}/${prefix}INT82${suffix} \
-V ${INDIR}/${prefix}INT83${suffix} \
-V ${INDIR}/${prefix}INT84${suffix} \
-V ${INDIR}/${prefix}INT86${suffix} \
-V ${INDIR}/${prefix}INT88${suffix} \
-V ${INDIR}/${prefix}INT89${suffix} \
-V ${INDIR}/${prefix}INT90${suffix} \
-V ${INDIR}/${prefix}INT91${suffix} \
-V ${INDIR}/${prefix}INT92${suffix} \
-V ${INDIR}/${prefix}INT93${suffix} \
-V ${INDIR}/${prefix}INT97${suffix} \
-V ${INDIR}/${prefix}INT101${suffix} \
-V ${INDIR}/${prefix}INT102${suffix} \
-V ${INDIR}/${prefix}INT104${suffix} \
-V ${INDIR}/${prefix}INT106${suffix} \
-V ${INDIR}/${prefix}INT108${suffix} \
-V ${INDIR}/${prefix}INT109${suffix} \
-V ${INDIR}/${prefix}INT110${suffix} \
-V ${INDIR}/${prefix}INT111${suffix} \
-V ${INDIR}/${prefix}INT112${suffix} \
-V ${INDIR}/${prefix}INT113${suffix} \
-V ${INDIR}/${prefix}INT114${suffix} \
-V ${INDIR}/${prefix}INT115${suffix} \
-V ${INDIR}/${prefix}INT116${suffix} \
-V ${INDIR}/${prefix}INT117${suffix} \
-V ${INDIR}/${prefix}INT118${suffix} \
-V ${INDIR}/${prefix}INT119${suffix} \
--outputFile ${OUTDIR}/${prefix}'MergedScaffolds.vcf.gz' \
-assumeSorted

exitVal=${?}
if [ ${exitVal} -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %T")] FAIL"
    exit 1
fi

echo -e "[$(date "+%Y-%m-%d %T")] Done with CatVariants"

## Cleanup

echo "[$(date "+%Y-%m-%d %T")] Job ID: ${JOB_ID}.${SGE_TASK_ID}; Done combining VCF files with CatVariants"
conda deactivate