######################################################################
###### LD Pruning on all unrelated CAQU samples using SNPRelate ######
######################################################################

# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON JUN 24 2024

## References:
# http://bioconductor.org/packages/release/bioc/vignettes/SNPRelate/inst/doc/SNPRelate.html
# https://uw-gac.github.io/SISG_2021/ancestry-and-relatedness-inference.html
# https://github.com/snigenda/FinWhale_PopGenomics_2022/blob/eb6fc440af3357771216d8bb6f45490e6e7d9499/population_structure/pca_relatedness_fst_admixture/step1_gdsPASSLDPruning_all50_20210316.R

## Dependencies

library(gdsfmt)
library(SNPRelate)

## Read in Data

gdsfmt::showfile.gds(closeall=TRUE) # make sure file is not already open
gdsfile <- <insert patht to .gds file of all pass SNPs>
genofile <- snpgdsOpen(gdsfile, readonly = TRUE)
all_samples <- c("LACM107363","LACM107541","LACM112287","MVZCCGP-CaOr104_I-H10","MVZCCGP-CaOr30_I-F03","MVZCCGP-CaOr33_I-A04","MVZCCGP-CaOr35_I-C04","MVZCCGP-CaOr37_II-A01","MVZCCGP-CaOr45_I-C05","MVZCCGP-CaOr71_II-F01","MVZCCGP-CaOr78_II-H01","MVZCCGP-CaOr81_II-B02","MVZCCGP-CaOr96_I-A10","T05B038","T11B098","T11B111","T1B050","T1B052","T1B054","T1B075","T1B081","T1B082","T2B001","T2B029","T2B060","T2B084","T2B085","T2B086","T3B024","T3B032","T3B066","T3B091","T3B092","T3B109","T4B004","T4B009","T4B057","T4B073","T4B074","T4B096","T4B110","T5B093","T6B055","T6B067","T6B107","T7B013","T7B036","T8B041","T8B070","T8B094","T9B090","WFVZ52698","WFVZ53206")
samples_SAMO <- c("LACM107363","LACM107541","LACM112287","MVZCCGP-CaOr104_I-H10","MVZCCGP-CaOr30_I-F03","MVZCCGP-CaOr33_I-A04","MVZCCGP-CaOr35_I-C04","T05B038","T11B098","T11B111","T1B050","T1B052","T1B054","T1B075","T1B081","T1B082","T2B001","T2B029","T2B060","T2B084","T2B085","T2B086","T3B024","T3B032","T3B066","T3B091","T3B092","T3B109","T4B004","T4B009","T4B057","T4B073","T4B074","T4B096","T4B110","T5B093","T6B055","T6B067","T6B107","T7B013","T7B036","T8B041","T8B070","T8B094","T9B090","WFVZ52698","WFVZ53206")

## LD Pruning
set.seed(1000)

# all samples first
# Perform SNP LD Pruning for various Minor Allele Frequency (MAF) thresholds and various LD pruning thresholds
snpset_maf01_ld2 <- snpgdsLDpruning(genofile, ld.threshold = 0.2, maf = .01, autosome.only = FALSE, method = 'composite', sample.id=all_samples)

# Get the SNP ID names for the PCA
snpset_id_maf01_ld2 <- unlist(unname(snpset_maf01_ld2))

# Output new GDS files to use in SeqArray/PLINK/Admixture
snpgdsCreateGenoSet(gdsfile,paste0(<insert patht to .gds file of all pass SNPs>,"_maf01_ld2_allsamples.gds"),snp.id=snpset_id_maf01_ld2, sample.id=all_samples)

# Confirm that subset worked
gdsfmt::showfile.gds(closeall=TRUE)
gdsfile_pruned_allsamples <- <insert patht to .gds file of all pass SNPs>
genofile_pruned_allsamples <- snpgdsOpen(gdsfile_pruned_allsamples, readonly = TRUE)
sample_id_pruned_allsamples <- read.gdsn(index.gdsn(genofile_pruned_allsamples, "sample.id"))
print("Sample order after subset and pruning, all samples")
print(sample_id_pruned_allsamples)
gdsfmt::showfile.gds(closeall=TRUE)

# Now SAMO samples

gdsfile <- <insert patht to .gds file of all pass SNPs>
genofile <- snpgdsOpen(gdsfile, readonly = TRUE)

snpset_maf01_ld2_SAMO <- snpgdsLDpruning(genofile, ld.threshold = 0.2, maf = .01, autosome.only = FALSE, method = 'composite', sample.id=samples_SAMO)

# Get the SNP ID names for the PCA
snpset_id_maf01_ld2_SAMO <- unlist(unname(snpset_maf01_ld2_SAMO))

# Output new GDS files to use in SeqArray/PLINK/Admixture
snpgdsCreateGenoSet(gdsfile,paste0(<insert patht to .gds file of all pass SNPs>,"_maf01_ld2_SAMO.gds"),snp.id=snpset_id_maf01_ld2_SAMO, sample.id=samples_SAMO)

# Confirm that subset worked
gdsfmt::showfile.gds(closeall=TRUE)
gdsfile_pruned_SAMO <- <insert path to new .gds file with just SAMO samples>
genofile_pruned_SAMO <- snpgdsOpen(gdsfile_pruned_SAMO, readonly = TRUE)
sample_id_pruned_SAMO <- read.gdsn(index.gdsn(genofile_pruned_SAMO, "sample.id"))
print("Sample order after subset and pruning, unrelated SAMO samples")
print(sample_id_pruned_SAMO)
gdsfmt::showfile.gds(closeall=TRUE)
