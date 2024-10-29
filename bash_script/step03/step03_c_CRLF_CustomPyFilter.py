'''
Custom filtering of VCF files
Input: raw VCF
Output: filtered VCF prints to screen
- Sites failing filters are marked as FAIL_? or WARN_? in the 7th column
- Sites where REF is in [A,C,G,T] and ALT is in [A,C,G,T,.] go on to genotype filtering if AD and DP present in FORMAT
- Filtered out genotypes are changed to './.', all others reported
- Sites with non-reference alleles remaining after genotype filtering also filtered based on values in INFO column
Possible usage:
SCRIPT=step03_c_CRLF_CustomPyFilter.py
python ${SCRIPT} myfile.vcf.gz | bgzip > myfile_filtered.vcf.gz
tabix -p vcf myfile_filtered.vcf.gz
'''

import sys
import gzip
import re

vcf_file = sys.argv[1]
VCF = gzip.open(vcf_file, 'rt')

# Min depth (1/3x lowest sample coverage = 1/3(19) ~ 6)
minD = 6

# Max depth (99% of site-wide coverage per sample)
maxD = {'T05B038': 29, 'T11B098': 30, 'T11B111': 33, 'T1B050': 27, 'T1B052': 28, 'T1B054': 29, 'T1B075': 45, 'T1B081': 30, 'T1B082': 30, 'T1B083': 37, 'T2B001': 30, 'T2B029': 27, 'T2B060': 31, 'T2B084': 31, 'T2B085': 28, 'T2B086': 30, 'T2B087': 26, 'T2B088': 26, 'T2B089': 30, 'T3B024': 29, 'T3B032': 33, 'T3B066': 25, 'T3B091': 29, 'T3B092': 26, 'T3B103': 41, 'T3B109': 28, 'T4B004': 28,
        'T4B005': 26, 'T4B006': 27, 'T4B009': 30, 'T4B035': 40, 'T4B057': 30, 'T4B073': 35, 'T4B074': 24, 'T4B096': 32, 'T4B110': 38, 'T5B093': 30, 'T5B095': 25, 'T6B055': 26, 'T6B067': 37, 'T6B107': 30, 'T7B013': 29, 'T7B036': 33, 'T8B041': 28, 'T8B070': 29, 'T8B094': 27, 'T9B090': 31, 'MVZCCGP-CaOr104_I-H10': 29, 'MVZCCGP-CaOr30_I-F03': 27, 'MVZCCGP-CaOr33_I-A04': 25, 'MVZCCGP-CaOr35_I-C04': 27,
        'MVZCCGP-CaOr37_II-A01': 23, 'MVZCCGP-CaOr45_I-C05': 31, 'MVZCCGP-CaOr71_II-F01': 28, 'MVZCCGP-CaOr78_II-H01': 24, 'MVZCCGP-CaOr81_II-B02': 24, 'MVZCCGP-CaOr96_I-A10': 28, 'LACM107363': 19, 'LACM107541': 46, 'LACM112287': 46, 'WFVZ52698': 60, 'WFVZ53206': 52}


# Individual genotype filtering function
#  - Genotypes failing filters are set to missing (./.)
#  - Applies individual min and max depth filters
#  - **[Didn't Use this one]** Filters heterozygotes if the allele balance (REF/DP) is <20% or >80%
#  - Filters homozygotes if more than 10% of the alleles are different type
#  - 'sample' is the sample name
#  - 'GT_entry' is the entire genotype entry for that individual (typically GT:AD:DP:GQ)
#  - 'ADpos' is the position of the AD field in FORMAT (determined below)
#  - 'DPpos' is the position of the DP field in FORMAT (determined below)

def GTfilter(sample, GT_entry, ADpos, DPpos):
    if GT_entry[:1] == '.':
        return GT_entry
    else:
        gt = GT_entry.split(':')
        if gt[0] in ('0/0', '0/1', '1/1') and gt[DPpos] != '.':
            DP = int(gt[DPpos])
            if minD <= DP <= maxD[sample]:
                REF = float(gt[ADpos].split(',')[0])
                AB = float(REF / DP)
                if gt[0] == '0/0':
                    if AB >= 0.9:
                        return GT_entry
                    else:
                        return './.:' + ':'.join(gt[1:])
                elif gt[0] == '0/1':
                    if 0.2 <= AB <= 0.8:
                        return GT_entry
                    else:
                        return './.:' + ':'.join(gt[1:])
                elif gt[0] == '1/1':
                    if AB <= 0.1:
                        return GT_entry
                    else:
                        return './.:' + ':'.join(gt[1:])
                else:
                    './.:' + ':'.join(gt[1:])
            else:
                return './.:' + ':'.join(gt[1:])
        else:
            return './.:' + ':'.join(gt[1:])


# Get list of samples in VCF file
samples = []
for line in VCF:
    if line.startswith('##'):
        pass
    else:
        for i in line.split()[9:]: samples.append(i)
        break

# Go back to beginning of file
VCF.seek(0)

# Write pre-existing header lines & add new lines describing filters being applied
for line0 in VCF:
    if line0.startswith('#'):
        if line0.startswith('##FORMAT'):
            sys.stdout.write('##FILTER=<ID=FAIL_REF,Description="Reference allele not one of [A,C,G,T].">\n')
            sys.stdout.write('##FILTER=<ID=FAIL_ALT,Description="Alternate allele not one of [A,C,G,T,.].">\n')
            sys.stdout.write('##FILTER=<ID=FAIL_noADi,Description="AD not present in FORMAT.">\n')
            sys.stdout.write('##FILTER=<ID=FAIL_noDPi,Description="DP not present in FORMAT.">\n')
            sys.stdout.write('##FILTER=<ID=FAIL_noGT,Description="No called genotypes remain after filtering.">\n')
            sys.stdout.write('##FILTER=<ID=WARN_missing,Description="Excess missingness (>20% of samples uncalled or set to missing).">\n')
            sys.stdout.write('##FILTER=<ID=FAIL_QD,Description="QD < 4.0.">\n')
            sys.stdout.write('##FILTER=<ID=FAIL_FS,Description="FS > 12.0.">\n')
            sys.stdout.write('##FILTER=<ID=FAIL_MQ,Description="MQ < 40.0.">\n')
            sys.stdout.write('##FILTER=<ID=FAIL_MQRankSum,Description="MQRankSum < -12.5.">\n')
            sys.stdout.write('##FILTER=<ID=FAIL_ReadPosRankSum,Description="ReadPosRankSum < -8.0.">\n')
            sys.stdout.write('##FILTER=<ID=FAIL_SOR,Description="SOR > 3.0.">\n')
            sys.stdout.write(line0)
            break
        else:
            sys.stdout.write(line0)

# Removed excess het header line: sys.stdout.write('##FILTER=<ID=FAIL_excessHet,Description="Excess heterozygosity (>35% of genotypes are 0/1).">\n')

# Go through VCF file line by line to apply filters
for line0 in VCF:
    if line0.startswith('#'):
        sys.stdout.write(line0)
        continue
    line = line0.strip().split('\t')

    ### Site filtering:
    ### Keep any filters that have already been applied
    filter = []
    if line[6] not in ('.', 'PASS'):
        filter.append(line[6])

    ### Check REF allele
    if line[3] not in ['A', 'C', 'G', 'T']:
        filter.append('FAIL_REF')

    ### Check ALT allele
    if line[4] not in ['A', 'C', 'G', 'T', '.']:
        filter.append('FAIL_ALT')

    ### Access INFO field annotations
    if ';' in line[7]:
        INFO = line[7].split(';')
        d = dict(x.split('=') for x in INFO)
    else:
        INFO = line[7]
        if '=' in INFO:
            d = {INFO.split('=')[0]: INFO.split('=')[1]}
        else:
            d = {}

    ### Get the position of AD, DP in genotype fields
    if 'AD' in line[8]:
        ADpos = line[8].split(':').index('AD')
    else:
        filter.append('FAIL_noADi')

    if 'DP' in line[8]:
        DPpos = line[8].split(':').index('DP')
    else:
        filter.append('FAIL_noDPi')

    ### If any filters failed, write out line and continue
    if filter != []:
        sys.stdout.write('%s\t%s\t%s\n' % ('\t'.join(line[0:6]), ';'.join(filter), '\t'.join(line[7:])))
        continue

    ### Genotype filtering:
    GT_list = []
    for i in range(0, len(samples)):
        GT = GTfilter(samples[i], line[i + 9], ADpos, DPpos)
        GT_list.append(GT)

    ### Recalculate AC, AN, AF for INFO (after this step, modified INFO values will be output)
    REF = 2 * [x[:3] for x in GT_list].count('0/0') + [x[:3] for x in GT_list].count('0/1')
    ALT = 2 * [x[:3] for x in GT_list].count('1/1') + [x[:3] for x in GT_list].count('0/1')
    if REF + ALT == 0:
        filter.append('FAIL_noGT')
        sys.stdout.write('%s\t%s\t%s\t%s\n' % ('\t'.join(line[0:6]), ';'.join(filter), '\t'.join(line[7:9]), '\t'.join(GT_list)))
        continue
    d['AC'] = ALT
    d['AN'] = REF + ALT
    d['AF'] = round(float(ALT) / (float(REF) + float(ALT)), 4)

    ### Warn if >20% of genotypes missing
    n_missing = sum(x[:3] == './.' for x in GT_list)
    if n_missing > 0.20 * len(samples):
        filter.append('WARN_missing')

    ### Fail sites with excess heterozygosity (>75% of genotypes are heterozygous)
    #    n_het=sum(x[:3]=='0/1' for x in GT_list)
    #   n_called=sum(x[:3]!='./.' for x in GT_list)
    #    if float(n_het/n_called)>0.35:
    #        filter.append('FAIL_excessHet')

    ### Set VariantType, outputting sites with just hom. REF genotypes without further filtering
    if ALT == 0:
        d['VariantType'] = 'NO_VARIATION'
        if filter == []:
            filter.append('PASS')
        sys.stdout.write('%s\t%s\t%s\t%s\t%s\n' % ('\t'.join(line[0:6]), ';'.join(filter), ';'.join('{0}={1}'.format(key, val) for key, val in sorted(d.items())), line[8], '\t'.join(GT_list)))
        continue
    elif REF == 0:
        d['VariantType'] = 'NO_VARIATION'
    else:
        d['VariantType'] = 'SNP'

    ### Fail sites with poor variant metrics
    if 'QD' in d and float(d['QD']) < 4.0:
        filter.append('FAIL_QD')
    if 'FS' in d and float(d['FS']) > 12.0:
        filter.append('FAIL_FS')
    if 'MQ' in d and float(d['MQ']) < 40.0:
        filter.append('FAIL_MQ')
    if 'MQRankSum' in d and float(d['MQRankSum']) < -12.5:
        filter.append('FAIL_MQRankSum')
    if 'ReadPosRankSum' in d and float(d['ReadPosRankSum']) < -8.0:
        filter.append('FAIL_ReadPosRankSum')
    if 'SOR' in d and float(d['SOR']) > 3.0:
        filter.append('FAIL_SOR')

    ### Write out new line
    if filter == []:
        filter.append('PASS')
    sys.stdout.write('%s\t%s\t%s\t%s\t%s\n' % ('\t'.join(line[0:6]), ';'.join(filter), ';'.join('{0}={1}'.format(key, val) for key, val in sorted(d.items())), line[8], '\t'.join(GT_list)))

# Close files and exit
VCF.close()
exit()