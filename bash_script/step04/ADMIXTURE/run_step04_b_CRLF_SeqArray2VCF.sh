#!/bin/bash
#$ -l highp,h_data=20G,h_rt=10:00:00
#$ -wd <insert path to working directory>
#$ -o <insert log directory path>
#$ -e <insert log directory path>
#$ -m bae
#$ -M 1joeynik
#$ -N step04_b_CAQU_SeqArray2VCF

## Import Packages

source <insert path to miniconda>
conda activate my_SNPRelate

set -o pipefail

## Main

Rscript step04_b_CAQU_SeqArray2VCF_20240624.R

## Clean Up
echo -e "[$(date "+%Y-%m-%d %T")] Done"

conda deactivate
