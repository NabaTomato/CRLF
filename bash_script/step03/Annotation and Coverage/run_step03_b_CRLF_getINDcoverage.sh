#!/bin/bash
#$ -l highp,h_rt=24:00:00,h_data=20G,h_vmem=40G
#$ -pe shared 2
#$ -N step03_b_CAQU_getINDcoverage
#$ -cwd
#$ -m bea
#$ -o <insert log directory path>
#$ -e <insert log directory path>
#$ -M 1joeynik

# Version: V2 - adding in 2024 samples from MVZ, NHMLA, and WFVZ
# Usage: qsub -t 1-119:1 run_step03_b_CRLF_getINDcoverage.sh
# Description: This script is the wrapper script to submit the custom python script step03_b_CAQU_getINDcoverage_20240602.py which gets individual depth values for individuals in a joint VCF
# Author: Chris Kyriazis
# Adapted By: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON JUN 02 2024

# Note: need to change to your path for python
. /u/local/Modules/default/init/modules.sh
module load python/2.7.15

python step03_b_CAQU_getINDcoverage_20240602.py ${SGE_TASK_ID}
sleep 200s