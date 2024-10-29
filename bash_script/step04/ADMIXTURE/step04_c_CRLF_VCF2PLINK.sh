####################################################################
###### Converting SNPRelate GDS file to VCF File in SNPRelate ######
####################################################################

# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON JUN 24 2024

## References:
# http://bioconductor.org/packages/release/bioc/vignettes/SNPRelate/inst/doc/SNPRelate.html
# https://uw-gac.github.io/SISG_2021/ancestry-and-relatedness-inference.html

## Dependencies

library(gdsfmt)
library(SNPRelate)
library(SeqArray)

## Read in Data, Define Variables

infile_allsamples <- "GCA_023055505.1_bCalCai1.0.p_PassSNPs_maf01_ld2_allsamples.gds"
outfile1_allsamples <- "GCA_023055505.1_bCalCai1.0.p_PassSNPs_maf01_ld2_allsamples_SeqArrayIntFile.gds"
outfile2_allsamples <- "GCA_023055505.1_bCalCai1.0.p_PassSNPs_maf01_ld2_allsamples_GDS2VCF.vcf"

infile_SAMO <- "GCA_023055505.1_bCalCai1.0.p_PassSNPs_maf01_ld2_SAMO.gds"
outfile1_SAMO <- "GCA_023055505.1_bCalCai1.0.p_PassSNPs_maf01_ld2_SAMO_SeqArrayIntFile.gds"
outfile2_SAMO <- "GCA_023055505.1_bCalCai1.0.p_PassSNPs_maf01_ld2_SAMO_GDS2VCF.vcf"

majorref <- FALSE

## Main

# note this: https://github.com/zhengxwen/SeqArray/issues/22
# default to: major.ref	= TRUE
# if TRUE, use the major allele as a reference allele; otherwise, use A allele in SNP GDS file as a reference allele
# SA_mrF: SeqArray format; majorref = FALSE

# First on all unrelated samples including outgroups

SeqArray::seqSNP2GDS(infile_allsamples, outfile1_allsamples, verbose=TRUE, optimize=FALSE, major.ref = majorref)

# open the file

SeqArray::seqSummary(outfile1_allsamples)
genofile_allsamples <- SeqArray::seqOpen(outfile1_allsamples)

# convert to vcf (don't gzip)

SeqArray::seqGDS2VCF(genofile_allsamples, vcf.fn = outfile2_allsamples)

# close the GDS file

seqClose(genofile_allsamples)

# Now just on SAMO samples

SeqArray::seqSNP2GDS(infile_SAMO, outfile1_SAMO, verbose=TRUE, optimize=FALSE, major.ref = majorref)

# open the file

SeqArray::seqSummary(outfile1_SAMO)
genofile_SAMO <- SeqArray::seqOpen(outfile1_SAMO)

# convert to vcf (don't gzip)

SeqArray::seqGDS2VCF(genofile_SAMO, vcf.fn = outfile2_SAMO)

# close the GDS file

seqClose(genofile_SAMO)

## Clean up
write("Finished converting GDS to VCF on:", stdout())
date()
closeAllConnections()

