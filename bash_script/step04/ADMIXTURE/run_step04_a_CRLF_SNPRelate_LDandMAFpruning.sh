#!/bin/bash
#$ -l highp,h_data=20G,h_rt=10:00:00
#$ -wd <insert working directory path>
#$ -o <insert log directory path>
#$ -e <insert log directory path>
#$ -m bae
#$ -M 1joeynik
#$ -N step04_a_CAQU_SNPRelate_LDandMAFpruning

## Import Packages

source <insert path to miniconda>
conda activate my_SNPRelate

set -o pipefail

## Main

Rscript step04_a_CAQU_SNPRelate_LDandMAFpruning_20240624.R

## Clean Up
echo -e "[$(date "+%Y-%m-%d %T")] Done"

conda deactivate
