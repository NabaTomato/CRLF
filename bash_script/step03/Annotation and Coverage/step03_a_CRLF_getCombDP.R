## Determining the DP hard filter for CAQU genomes

# Author: Joseph Curti (jcurti3@g.ucla.edu)
# Date: MON JUN 10 2024
# Description: read in SNPs tables and calculate the 99th percentile of depth across all samples

#clean workspace and set wd
rm(list=ls())
setwd("~/Downloads/tables/")

#read in the snps_tables
listtxt <- dir(pattern = "*.txt") # creates the list of all the csv files in the directory
for(i in 1:length(listtxt)) {
  assign(paste0("snps", i),
         read.table(paste0("~/Downloads/tables/",
                          listtxt[i]), header = T))
}

#create a dataframe of snps_tables and get 99th percentile
df_list <- mget(ls(pattern = "snps*"))
DPs <- matrix(NA)
for(i in 1:length(df_list)) {
  DPs[i] <- quantile(df_list[[i]][[3]], probs = 0.99)
}

#visualize and summarize results
hist(DPs)
mean(DPs)
#2902.6
median(DPs)
#1495 <- this is probably a better number to use given the distribution