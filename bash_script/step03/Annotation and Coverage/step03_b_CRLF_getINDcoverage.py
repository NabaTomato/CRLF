# Version: V2 - Adding in samples from 2024 from MVZ, NHMLA, and WFVZ
# Description: Writes to file the filered depth (from the genotype fields) for each individuual. i.e. there is one file for each individual/chromosome. I will then cat these per indiv to get sum.
# Author: Chris Kyriazis
# Adapted by: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON JUN 02 2024

## SETUP WORKSPACE  ##

import vcf
import sys

## Define Variables ##

scaffold = sys.argv[1]
filename = 'GCA_023055505.1_bCalCai1.0.p_INT' + str(scaffold) + '_VariantAnnotator.vcf.gz'
indir = '/u/home/1/1joeynik/project-rwayne/CAQU/preprocessing/VCFs/2024/VariantAnnotator/'
myvcffile = indir + filename
outd = '/u/home/1/1joeynik/project-rwayne/CAQU/stats/getINDcoverage/'
mysamples = ['T11B098', 'T1B075', 'T1B081', 'T1B083', 'T2B088', 'T3B066', 'T3B091', 'T3B092', 'T3B103', 'T4B035', 'T4B073', 'T4B074', 'T6B067', 'T6B107', 'T7B036', 'T8B041', 'T8B070', 'T8B094', 'T1B050', 'T2B086', 'T5B095', 'T4B006', 'T9B090', 'T4B110', 'T4B005', 'T1B082', 'T1B052', 'T4B009', 'T1B054', 'T2B085', 'T05B038', 'T2B084', 'T2B029', 'T4B057', 'T11B111', 'T5B093', 'T2B001', 'T2B089',
             'T4B096', 'T4B004', 'T6B055', 'T2B087', 'T2B060', 'T3B024', 'T3B109', 'T3B032', 'T7B013', 'LACM107363', 'LACM107541', 'LACM112287', 'WFVZ52698', 'WFVZ53206', 'MVZCCGP-CaOr35_I-C04', 'MVZCCGP-CaOr33_I-A04', 'MVZCCGP-CaOr30_I-F03', 'MVZCCGP-CaOr104_I-H10', 'MVZCCGP-CaOr81_II-B02', 'MVZCCGP-CaOr78_II-H01', 'MVZCCGP-CaOr71_II-F01', 'MVZCCGP-CaOr96_I-A10', 'MVZCCGP-CaOr45_I-C05',
             'MVZCCGP-CaOr37_II-A01']

ofT11B098 = open(outd + 'T11B098_' + 'scaffold' + scaffold + '.txt', 'a')
ofT1B075 = open(outd + 'T1B075_' + 'scaffold' + scaffold + '.txt', 'a')
ofT1B081 = open(outd + 'T1B081_' + 'scaffold' + scaffold + '.txt', 'a')
ofT1B083 = open(outd + 'T1B083_' + 'scaffold' + scaffold + '.txt', 'a')
ofT2B088 = open(outd + 'T2B088_' + 'scaffold' + scaffold + '.txt', 'a')
ofT3B066 = open(outd + 'T3B066_' + 'scaffold' + scaffold + '.txt', 'a')
ofT3B091 = open(outd + 'T3B091_' + 'scaffold' + scaffold + '.txt', 'a')
ofT3B092 = open(outd + 'T3B092_' + 'scaffold' + scaffold + '.txt', 'a')
ofT3B103 = open(outd + 'T3B103_' + 'scaffold' + scaffold + '.txt', 'a')
ofT4B035 = open(outd + 'T4B035_' + 'scaffold' + scaffold + '.txt', 'a')
ofT4B073 = open(outd + 'T4B073_' + 'scaffold' + scaffold + '.txt', 'a')
ofT4B074 = open(outd + 'T4B074_' + 'scaffold' + scaffold + '.txt', 'a')
ofT6B067 = open(outd + 'T6B067_' + 'scaffold' + scaffold + '.txt', 'a')
ofT6B107 = open(outd + 'T6B107_' + 'scaffold' + scaffold + '.txt', 'a')
ofT7B036 = open(outd + 'T7B036_' + 'scaffold' + scaffold + '.txt', 'a')
ofT8B041 = open(outd + 'T8B041_' + 'scaffold' + scaffold + '.txt', 'a')
ofT8B070 = open(outd + 'T8B070_' + 'scaffold' + scaffold + '.txt', 'a')
ofT8B094 = open(outd + 'T8B094_' + 'scaffold' + scaffold + '.txt', 'a')
ofT1B050 = open(outd + 'T1B050_' + 'scaffold' + scaffold + '.txt', 'a')
ofT2B086 = open(outd + 'T2B086_' + 'scaffold' + scaffold + '.txt', 'a')
ofT5B095 = open(outd + 'T5B095_' + 'scaffold' + scaffold + '.txt', 'a')
ofT4B006 = open(outd + 'T4B006_' + 'scaffold' + scaffold + '.txt', 'a')
ofT9B090 = open(outd + 'T9B090_' + 'scaffold' + scaffold + '.txt', 'a')
ofT4B110 = open(outd + 'T4B110_' + 'scaffold' + scaffold + '.txt', 'a')
ofT4B005 = open(outd + 'T4B005_' + 'scaffold' + scaffold + '.txt', 'a')
ofT1B082 = open(outd + 'T1B082_' + 'scaffold' + scaffold + '.txt', 'a')
ofT1B052 = open(outd + 'T1B052_' + 'scaffold' + scaffold + '.txt', 'a')
ofT4B009 = open(outd + 'T4B009_' + 'scaffold' + scaffold + '.txt', 'a')
ofT1B054 = open(outd + 'T1B054_' + 'scaffold' + scaffold + '.txt', 'a')
ofT2B085 = open(outd + 'T2B085_' + 'scaffold' + scaffold + '.txt', 'a')
ofT05B038 = open(outd + 'T05B038_' + 'scaffold' + scaffold + '.txt', 'a')
ofT2B084 = open(outd + 'T2B084_' + 'scaffold' + scaffold + '.txt', 'a')
ofT2B029 = open(outd + 'T2B029_' + 'scaffold' + scaffold + '.txt', 'a')
ofT4B057 = open(outd + 'T4B057_' + 'scaffold' + scaffold + '.txt', 'a')
ofT11B111 = open(outd + 'T11B111_' + 'scaffold' + scaffold + '.txt', 'a')
ofT5B093 = open(outd + 'T5B093_' + 'scaffold' + scaffold + '.txt', 'a')
ofT2B001 = open(outd + 'T2B001_' + 'scaffold' + scaffold + '.txt', 'a')
ofT2B089 = open(outd + 'T2B089_' + 'scaffold' + scaffold + '.txt', 'a')
ofT4B096 = open(outd + 'T4B096_' + 'scaffold' + scaffold + '.txt', 'a')
ofT4B004 = open(outd + 'T4B004_' + 'scaffold' + scaffold + '.txt', 'a')
ofT6B055 = open(outd + 'T6B055_' + 'scaffold' + scaffold + '.txt', 'a')
ofT2B087 = open(outd + 'T2B087_' + 'scaffold' + scaffold + '.txt', 'a')
ofT2B060 = open(outd + 'T2B060_' + 'scaffold' + scaffold + '.txt', 'a')
ofT3B024 = open(outd + 'T3B024_' + 'scaffold' + scaffold + '.txt', 'a')
ofT3B109 = open(outd + 'T3B109_' + 'scaffold' + scaffold + '.txt', 'a')
ofT3B032 = open(outd + 'T3B032_' + 'scaffold' + scaffold + '.txt', 'a')
ofT7B013 = open(outd + 'T7B013_' + 'scaffold' + scaffold + '.txt', 'a')
ofLACM107363 = open(outd + 'LACM107363_' + 'scaffold' + scaffold + '.txt', 'a')
ofLACM107541 = open(outd + 'LACM107541_' + 'scaffold' + scaffold + '.txt', 'a')
ofLACM112287 = open(outd + 'LACM112287_' + 'scaffold' + scaffold + '.txt', 'a')
ofWFVZ52698 = open(outd + 'WFVZ52698_' + 'scaffold' + scaffold + '.txt', 'a')
ofWFVZ53206 = open(outd + 'WFVZ53206_' + 'scaffold' + scaffold + '.txt', 'a')
ofMVZCCGP_CaOr35_I_C04 = open(outd + 'MVZCCGP_CaOr35_I_C04_' + 'scaffold' + scaffold + '.txt', 'a')
ofMVZCCGP_CaOr33_I_A04 = open(outd + 'MVZCCGP_CaOr33_I_A04_' + 'scaffold' + scaffold + '.txt', 'a')
ofMVZCCGP_CaOr30_I_F03 = open(outd + 'MVZCCGP_CaOr30_I_F03_' + 'scaffold' + scaffold + '.txt', 'a')
ofMVZCCGP_CaOr104_I_H10 = open(outd + 'MVZCCGP_CaOr104_I_H10_' + 'scaffold' + scaffold + '.txt', 'a')
ofMVZCCGP_CaOr81_II_B02 = open(outd + 'MVZCCGP_CaOr81_II_B02_' + 'scaffold' + scaffold + '.txt', 'a')
ofMVZCCGP_CaOr78_II_H01 = open(outd + 'MVZCCGP_CaOr78_II_H01_' + 'scaffold' + scaffold + '.txt', 'a')
ofMVZCCGP_CaOr71_II_F01 = open(outd + 'MVZCCGP_CaOr71_II_F01_' + 'scaffold' + scaffold + '.txt', 'a')
ofMVZCCGP_CaOr96_I_A10 = open(outd + 'MVZCCGP_CaOr96_I_A10_' + 'scaffold' + scaffold + '.txt', 'a')
ofMVZCCGP_CaOr45_I_C05 = open(outd + 'MVZCCGP_CaOr45_I_C05_' + 'scaffold' + scaffold + '.txt', 'a')
ofMVZCCGP_CaOr37_II_A01 = open(outd + 'MVZCCGP_CaOr37_II_A01_' + 'scaffold' + scaffold + '.txt', 'a')

## MAIN ##

vcf_reader = vcf.Reader(open(myvcffile, 'r'))

for record in vcf_reader:
    # skip the sites that dont have DP
    if 'DP' not in record.FORMAT:
        pass
    else:
        T11B098_DP = record.genotype('T11B098')['DP']
        if T11B098_DP > 0:
            ofT11B098.write(str(T11B098_DP) + '\n')

        T1B075_DP = record.genotype('T1B075')['DP']
        if T1B075_DP > 0:
            ofT1B075.write(str(T1B075_DP) + '\n')

        T1B081_DP = record.genotype('T1B081')['DP']
        if T1B081_DP > 0:
            ofT1B081.write(str(T1B081_DP) + '\n')

        T1B083_DP = record.genotype('T1B083')['DP']
        if T1B083_DP > 0:
            ofT1B083.write(str(T1B083_DP) + '\n')

        T2B088_DP = record.genotype('T2B088')['DP']
        if T2B088_DP > 0:
            ofT2B088.write(str(T2B088_DP) + '\n')

        T3B066_DP = record.genotype('T3B066')['DP']
        if T3B066_DP > 0:
            ofT3B066.write(str(T3B066_DP) + '\n')

        T3B091_DP = record.genotype('T3B091')['DP']
        if T3B091_DP > 0:
            ofT3B091.write(str(T3B091_DP) + '\n')

        T3B092_DP = record.genotype('T3B092')['DP']
        if T3B092_DP > 0:
            ofT3B092.write(str(T3B092_DP) + '\n')

        T3B103_DP = record.genotype('T3B103')['DP']
        if T3B103_DP > 0:
            ofT3B103.write(str(T3B103_DP) + '\n')

        T4B035_DP = record.genotype('T4B035')['DP']
        if T4B035_DP > 0:
            ofT4B035.write(str(T4B035_DP) + '\n')

        T4B073_DP = record.genotype('T4B073')['DP']
        if T4B073_DP > 0:
            ofT4B073.write(str(T4B073_DP) + '\n')

        T4B074_DP = record.genotype('T4B074')['DP']
        if T4B074_DP > 0:
            ofT4B074.write(str(T4B074_DP) + '\n')

        T6B067_DP = record.genotype('T6B067')['DP']
        if T6B067_DP > 0:
            ofT6B067.write(str(T6B067_DP) + '\n')

        T6B107_DP = record.genotype('T6B107')['DP']
        if T6B107_DP > 0:
            ofT6B107.write(str(T6B107_DP) + '\n')

        T7B036_DP = record.genotype('T7B036')['DP']
        if T7B036_DP > 0:
            ofT7B036.write(str(T7B036_DP) + '\n')

        T8B041_DP = record.genotype('T8B041')['DP']
        if T8B041_DP > 0:
            ofT8B041.write(str(T8B041_DP) + '\n')

        T8B070_DP = record.genotype('T8B070')['DP']
        if T8B070_DP > 0:
            ofT8B070.write(str(T8B070_DP) + '\n')

        T8B094_DP = record.genotype('T8B094')['DP']
        if T8B094_DP > 0:
            ofT8B094.write(str(T8B094_DP) + '\n')

        T1B050_DP = record.genotype('T1B050')['DP']
        if T1B050_DP > 0:
            ofT1B050.write(str(T1B050_DP) + '\n')

        T2B086_DP = record.genotype('T2B086')['DP']
        if T2B086_DP > 0:
            ofT2B086.write(str(T2B086_DP) + '\n')

        T5B095_DP = record.genotype('T5B095')['DP']
        if T5B095_DP > 0:
            ofT5B095.write(str(T5B095_DP) + '\n')

        T4B006_DP = record.genotype('T4B006')['DP']
        if T4B006_DP > 0:
            ofT4B006.write(str(T4B006_DP) + '\n')

        T9B090_DP = record.genotype('T9B090')['DP']
        if T9B090_DP > 0:
            ofT9B090.write(str(T9B090_DP) + '\n')

        T4B110_DP = record.genotype('T4B110')['DP']
        if T4B110_DP > 0:
            ofT4B110.write(str(T4B110_DP) + '\n')

        T4B005_DP = record.genotype('T4B005')['DP']
        if T4B005_DP > 0:
            ofT4B005.write(str(T4B005_DP) + '\n')

        T1B082_DP = record.genotype('T1B082')['DP']
        if T1B082_DP > 0:
            ofT1B082.write(str(T1B082_DP) + '\n')

        T1B052_DP = record.genotype('T1B052')['DP']
        if T1B052_DP > 0:
            ofT1B052.write(str(T1B052_DP) + '\n')

        T4B009_DP = record.genotype('T4B009')['DP']
        if T4B009_DP > 0:
            ofT4B009.write(str(T4B009_DP) + '\n')

        T1B054_DP = record.genotype('T1B054')['DP']
        if T1B054_DP > 0:
            ofT1B054.write(str(T1B054_DP) + '\n')

        T2B085_DP = record.genotype('T2B085')['DP']
        if T2B085_DP > 0:
            ofT2B085.write(str(T2B085_DP) + '\n')

        T05B038_DP = record.genotype('T05B038')['DP']
        if T05B038_DP > 0:
            ofT05B038.write(str(T05B038_DP) + '\n')

        T2B084_DP = record.genotype('T2B084')['DP']
        if T2B084_DP > 0:
            ofT2B084.write(str(T2B084_DP) + '\n')

        T2B029_DP = record.genotype('T2B029')['DP']
        if T2B029_DP > 0:
            ofT2B029.write(str(T2B029_DP) + '\n')

        T4B057_DP = record.genotype('T4B057')['DP']
        if T4B057_DP > 0:
            ofT4B057.write(str(T4B057_DP) + '\n')

        T11B111_DP = record.genotype('T11B111')['DP']
        if T11B111_DP > 0:
            ofT11B111.write(str(T11B111_DP) + '\n')

        T5B093_DP = record.genotype('T5B093')['DP']
        if T5B093_DP > 0:
            ofT5B093.write(str(T5B093_DP) + '\n')

        T2B001_DP = record.genotype('T2B001')['DP']
        if T2B001_DP > 0:
            ofT2B001.write(str(T2B001_DP) + '\n')

        T2B089_DP = record.genotype('T2B089')['DP']
        if T2B089_DP > 0:
            ofT2B089.write(str(T2B089_DP) + '\n')

        T4B096_DP = record.genotype('T4B096')['DP']
        if T4B096_DP > 0:
            ofT4B096.write(str(T4B096_DP) + '\n')

        T4B004_DP = record.genotype('T4B004')['DP']
        if T4B004_DP > 0:
            ofT4B004.write(str(T4B004_DP) + '\n')

        T6B055_DP = record.genotype('T6B055')['DP']
        if T6B055_DP > 0:
            ofT6B055.write(str(T6B055_DP) + '\n')

        T2B087_DP = record.genotype('T2B087')['DP']
        if T2B087_DP > 0:
            ofT2B087.write(str(T2B087_DP) + '\n')

        T2B060_DP = record.genotype('T2B060')['DP']
        if T2B060_DP > 0:
            ofT2B060.write(str(T2B060_DP) + '\n')

        T3B024_DP = record.genotype('T3B024')['DP']
        if T3B024_DP > 0:
            ofT3B024.write(str(T3B024_DP) + '\n')

        T3B109_DP = record.genotype('T3B109')['DP']
        if T3B109_DP > 0:
            ofT3B109.write(str(T3B109_DP) + '\n')

        T3B032_DP = record.genotype('T3B032')['DP']
        if T3B032_DP > 0:
            ofT3B032.write(str(T3B032_DP) + '\n')

        T7B013_DP = record.genotype('T7B013')['DP']
        if T7B013_DP > 0:
            ofT7B013.write(str(T7B013_DP) + '\n')

        LACM107363_DP = record.genotype('LACM107363')['DP']
        if LACM107363_DP > 0:
            ofLACM107363.write(str(LACM107363_DP) + '\n')

        LACM107541_DP = record.genotype('LACM107541')['DP']
        if LACM107541_DP > 0:
            ofLACM107541.write(str(LACM107541_DP) + '\n')

        LACM112287_DP = record.genotype('LACM112287')['DP']
        if LACM112287_DP > 0:
            ofLACM112287.write(str(LACM112287_DP) + '\n')

        WFVZ52698_DP = record.genotype('WFVZ52698')['DP']
        if WFVZ52698_DP > 0:
            ofWFVZ52698.write(str(WFVZ52698_DP) + '\n')

        WFVZ53206_DP = record.genotype('WFVZ53206')['DP']
        if WFVZ53206_DP > 0:
            ofWFVZ53206.write(str(WFVZ53206_DP) + '\n')

        MVZCCGP_CaOr35_I_C04_DP = record.genotype('MVZCCGP-CaOr35_I-C04')['DP']
        if MVZCCGP_CaOr35_I_C04_DP > 0:
            ofMVZCCGP_CaOr35_I_C04.write(str(MVZCCGP_CaOr35_I_C04_DP) + '\n')

        MVZCCGP_CaOr33_I_A04_DP = record.genotype('MVZCCGP-CaOr33_I-A04')['DP']
        if MVZCCGP_CaOr33_I_A04_DP > 0:
            ofMVZCCGP_CaOr33_I_A04.write(str(MVZCCGP_CaOr33_I_A04_DP) + '\n')

        MVZCCGP_CaOr30_I_F03_DP = record.genotype('MVZCCGP-CaOr30_I-F03')['DP']
        if MVZCCGP_CaOr30_I_F03_DP > 0:
            ofMVZCCGP_CaOr30_I_F03.write(str(MVZCCGP_CaOr30_I_F03_DP) + '\n')

        MVZCCGP_CaOr104_I_H10_DP = record.genotype('MVZCCGP-CaOr104_I-H10')['DP']
        if MVZCCGP_CaOr104_I_H10_DP > 0:
            ofMVZCCGP_CaOr104_I_H10.write(str(MVZCCGP_CaOr104_I_H10_DP) + '\n')

        MVZCCGP_CaOr81_II_B02_DP = record.genotype('MVZCCGP-CaOr81_II-B02')['DP']
        if MVZCCGP_CaOr81_II_B02_DP > 0:
            ofMVZCCGP_CaOr81_II_B02.write(str(MVZCCGP_CaOr81_II_B02_DP) + '\n')

        MVZCCGP_CaOr78_II_H01_DP = record.genotype('MVZCCGP-CaOr78_II-H01')['DP']
        if MVZCCGP_CaOr78_II_H01_DP > 0:
            ofMVZCCGP_CaOr78_II_H01.write(str(MVZCCGP_CaOr78_II_H01_DP) + '\n')

        MVZCCGP_CaOr71_II_F01_DP = record.genotype('MVZCCGP-CaOr71_II-F01')['DP']
        if MVZCCGP_CaOr71_II_F01_DP > 0:
            ofMVZCCGP_CaOr71_II_F01.write(str(MVZCCGP_CaOr71_II_F01_DP) + '\n')

        MVZCCGP_CaOr96_I_A10_DP = record.genotype('MVZCCGP-CaOr96_I-A10')['DP']
        if MVZCCGP_CaOr96_I_A10_DP > 0:
            ofMVZCCGP_CaOr96_I_A10.write(str(MVZCCGP_CaOr96_I_A10_DP) + '\n')

        MVZCCGP_CaOr45_I_C05_DP = record.genotype('MVZCCGP-CaOr45_I-C05')['DP']
        if MVZCCGP_CaOr45_I_C05_DP > 0:
            ofMVZCCGP_CaOr45_I_C05.write(str(MVZCCGP_CaOr45_I_C05_DP) + '\n')

        MVZCCGP_CaOr37_II_A01_DP = record.genotype('MVZCCGP-CaOr37_II-A01')['DP']
        if MVZCCGP_CaOr37_II_A01_DP > 0:
            ofMVZCCGP_CaOr37_II_A01.write(str(MVZCCGP_CaOr37_II_A01_DP) + '\n')

ofT11B098.close()
ofT1B075.close()
ofT1B081.close()
ofT1B083.close()
ofT2B088.close()
ofT3B066.close()
ofT3B091.close()
ofT3B092.close()
ofT3B103.close()
ofT4B035.close()
ofT4B073.close()
ofT4B074.close()
ofT6B067.close()
ofT6B107.close()
ofT7B036.close()
ofT8B041.close()
ofT8B070.close()
ofT8B094.close()
ofT1B050.close()
ofT2B086.close()
ofT5B095.close()
ofT4B006.close()
ofT9B090.close()
ofT4B110.close()
ofT4B005.close()
ofT1B082.close()
ofT1B052.close()
ofT4B009.close()
ofT1B054.close()
ofT2B085.close()
ofT05B038.close()
ofT2B084.close()
ofT2B029.close()
ofT4B057.close()
ofT11B111.close()
ofT5B093.close()
ofT2B001.close()
ofT2B089.close()
ofT4B096.close()
ofT4B004.close()
ofT6B055.close()
ofT2B087.close()
ofT2B060.close()
ofT3B024.close()
ofT3B109.close()
ofT3B032.close()
ofT7B013.close()
ofLACM107363.close()
ofLACM107541.close()
ofLACM112287.close()
ofWFVZ52698.close()
ofWFVZ53206.close()
ofMVZCCGP_CaOr35_I_C04.close()
ofMVZCCGP_CaOr33_I_A04.close()
ofMVZCCGP_CaOr30_I_F03.close()
ofMVZCCGP_CaOr104_I_H10.close()
ofMVZCCGP_CaOr81_II_B02.close()
ofMVZCCGP_CaOr78_II_H01.close()
ofMVZCCGP_CaOr71_II_F01.close()
ofMVZCCGP_CaOr96_I_A10.close()
ofMVZCCGP_CaOr45_I_C05.close()
ofMVZCCGP_CaOr37_II_A01.close()