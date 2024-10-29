#####################################################
## Determining the DP hard filter for CAQU genomes ##
#####################################################

# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON JUN 10 2024
# Description: Read in table of VCF annotations, visualize, summarize. Used to determine some of the hard filters for VCF
# Version 2 - including samples from WFVZ, NHMLA, WFVZ

# References:
# https://gatk.broadinstitute.org/hc/en-us/articles/360035890471-Hard-filtering-germline-short-variants
# https://speciationgenomics.github.io/filtering_vcfs/

## Clean workspace and set wd
rm(list=ls())
setwd(<insert working directory path>)

## Dependencies

library(ggplot2)
library(ggpubr)

## Read in the snps_tables

caqu_snps <- read.table(<insert SNPs tables directory path>,header = T,stringsAsFactors = F)
names(caqu_snps)
# "AN", "BaseQRankSum", "DP", "FS", "MQ", "MQRankSum", QD", "ReadPosRankSum", "SOR"

## Get summary stats on different annotations

# AN = total number of alleles in called genotypes
summary(caqu_snps$AN)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# 2.0   122.0   124.0   121.5   124.0   124.0

ppAN <- ggplot(caqu_snps, aes(x=AN)) + geom_density() + theme_pubr()

ggsave(filename="CAQU_AnnotationPlot_AN.png",plot=ppAN,device="png",dpi=300)

# BaseQRankSum = This variant-level annotation tests compares the base qualities of the data
# supporting the reference allele with those supporting the alternate allele. Ideal value = 0.
# negative value = bases for alternate allele are lower qual. than those for reference allele.
# positive value = bases for alternate allele are higher qual. than those for reference allele.

summary(caqu_snps$BaseQRankSum)
#Min. 1st Qu.  Median    Mean   3rd Qu.  Max.    NA's
#-11.3    -0.6     0.0    -0.2     0.4    11.7  769797

ppBQRS <- ggplot(caqu_snps, aes(x=BaseQRankSum)) + geom_density() + theme_pubr()
# mostly zero, that's good

ggsave(filename="CAQU_AnnotationPlot_BQRS.png",plot=ppBQRS,device="png",dpi=300)

# DP = combined depth across samples

summary(caqu_snps$DP)
#Min. 1st Qu.  Median    Mean  3rd Qu.    Max.
#1     937     994    1015    1053  105532

ppDP <- ggplot(caqu_snps, aes(x=DP)) + geom_density() + theme_pubr()
# Super long tail

ggsave(filename="CAQU_AnnotationPlot_DP.png",plot=ppDP,device="png",dpi=300)

quantile(caqu_snps$DP,probs = .99)
#2326
quantile(caqu_snps$DP,probs = .95)
#1172

# FS and SOR = They both measure strand bias. FS is the result of using those counts in a Fisher's
# Exact Test. SOR is a related annotation that applies a different statistical test (using the
# SB counts) that is better for high coverage data.

summary(caqu_snps$FS)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#0.000   0.000   0.949   2.392   3.176 929.127

summary(caqu_snps$SOR)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#0.0000  0.5260  0.6930  0.7924  0.8830 16.4830

ppFS <- ggplot(caqu_snps, aes(x=FS)) + geom_density() + theme_pubr()
ppSOR <- ggplot(caqu_snps, aes(x=SOR)) + geom_density() + theme_pubr()
ppFS_SOR <- ggarrange(ppFS,ppSOR)
# FS is on average very low, but there is a long tail and max value is high.
# SOR plot is greater than 3 which is the cutoff on GATK forum for bias of one strand over the other

ggsave(filename="CAQU_AnnotationPlot_FS_SOR.png",plot=ppFS_SOR,device="png",dpi=300)

# QD = Quality by depth, or the variant confidence divided by the unfiltered depth of non-hom-ref
# samples

summary(caqu_snps$QD)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's
#0.00    5.34   15.00   13.56   19.49   44.64    1429
quantile(caqu_snps$QD,probs = .99,na.rm = T)
#33.58

ppQD <- ggplot(caqu_snps, aes(x=QD)) + geom_density() + theme_pubr() + geom_vline(xintercept=2, color="red")
# GATK filters < 2 here based on results from VQSR. We cannot perform this but I think the generic filter makes sense
# given the large left tail

ggsave(filename="CAQU_AnnotationPlot_QD.png",plot=ppQD,device="png",dpi=300)

# MQ and MQRankSum = MQ is the root mean square mapping quality over all the reads at the site and
# MQRankSum is u-based z-approximation from the Rank Sum Test for mapping qualities. It compares
# the mapping qualities of the reads supporting the reference allele and the alternate allele.
# positive value = mapping qualities of the reads supporting the alternate allele are higher than
# those supporting the reference allele. Negative value =  mapping qualities of the reference
# allele are higher

summary(caqu_snps$MQ)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#0      60      60     Inf      60     Inf     158

summary(caqu_snps$MQRankSum)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's
#-25.7     0.0     0.0     0.0     0.0    26.7  769797

ppMQ <- ggplot(caqu_snps, aes(x=MQ)) + geom_density() + theme_pubr() + geom_vline(xintercept=40, color="red")
ppMQRankSum <- ggplot(caqu_snps, aes(x=MQRankSum)) + geom_density() + theme_pubr() + geom_vline(xintercept=-12.5, color="red")
ppMQ_MQRankSum <- ggarrange(ppMQ,ppMQRankSum)
# GATK recommends removing MQ < 40 which would get rid of weird small peak, and MQ rank sum < -12.5, which would get rid of
# very negative rare values. This all sounds good.

ggsave(filename="CAQU_AnnotationPlot_MQ_MQRankSum.png",plot=ppMQ_MQRankSum,device="png",dpi=300)

# ReadRankSumPos = It compares whether the positions of the reference and alternate alleles are
# different within the reads. A negative value indicates that the alternate allele is found at
#the ends of reads more often than the reference allele; a positive value indicates that the
#reference allele is found at the ends of reads more often than the alternate allele. A value
# close to zero is best

summary(caqu_snps$ReadPosRankSum)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's
# -17.9    -0.3     0.1     0.1     0.6    27.8  872490

quantile(caqu_snps$ReadPosRankSum,probs = .99,na.rm = T)
# 1.98

ppReadPosRankSum <- ggplot(caqu_snps, aes(x=ReadPosRankSum)) + geom_density() + theme_pubr() + geom_vline(xintercept=-8, color="red")
# long tails here. The GATK recommendation is to remove everything below -8, and I think I would also probably want to
# filter everything on the other side as well (i.e., >8)

ggsave(filename="CAQU_AnnotationPlot_ReadPosRankSum.png",plot=ppReadPosRankSum,device="png",dpi=300)


