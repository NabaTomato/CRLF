# Read in BCFtools Filter Tally and Tally Up Filters by Scaffold #

# Author: Joey Curti
# Date: 2023 Mar 03
# Version: 1

## clean workspace and set wd

setwd("~/Downloads/")
rm(list = ls())

## Dependencies
install.packages("gtools")
install.packages("RColorBrewer")
library(gtools) # for mixedsort()
library(dplyr)
library(ggplot2)
library(tidyr) # for gather
library(RColorBrewer) # palettes for figure

## read in data

# read in the site filter tally .txt files

listtxt <- list.files(path="~/Downloads/SiteFilterTally/" ,pattern = "*") %>% mixedsort() # creates the list of all the csv files in the directory, mixed sort by INT###
scaff_range <- c(1:8,10:22,24,26:30,32:40,42:48,50:51,53:61,63:65,67:84,86:93,95:102,104:119) #need this because scaffold numbers are not contiguous

for(i in 1:length(scaff_range)) {
  assign(paste0("scaff", scaff_range[i], sep=""),
         read.table(paste0("~/Downloads/SiteFilterTally/", listtxt[i]), header = F))
}

# Quick note here: I originally had files for all scaffolds in this directory, even
# scaffolds that were removed due to match with X chromosome (that had empty filter tally files).
# This threw the error pasted below that was resolved when I removed empty filter tally
# files. Evidently, read.table won't work if a file is empty

# Error in read.table(paste0("~/Downloads/SiteFilterTally/", listtxt[i]),  :
# no lines available in input

## Main

# Create a list for each filter

# FAIL_DP
FAIL_DP <- matrix(NA)

for(i in scaff_range) {
  FAIL_DP[i] <- sum(subset(get(paste0("scaff",i))[grep("FAIL_DP",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  FAIL_DP <- FAIL_DP[!is.na(FAIL_DP)]
}

# PASS

PASS <- matrix(NA)

for(i in scaff_range) {
  PASS[i] <- sum(subset(get(paste0("scaff",i))[grep("PASS",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  PASS <- PASS[!is.na(PASS)]
}

# FAIL_qual

FAIL_qual <- matrix(NA)

for(i in scaff_range) {
  FAIL_qual[i] <- sum(subset(get(paste0("scaff",i))[grep("FAIL_qual",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  FAIL_qual <- FAIL_qual[!is.na(FAIL_qual)]
}

# FAIL_Rep

FAIL_Rep <- matrix(NA)

for(i in scaff_range) {
  FAIL_Rep[i] <- sum(subset(get(paste0("scaff",i))[grep("FAIL_Rep",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  FAIL_Rep <- FAIL_Rep[!is.na(FAIL_Rep)]
}

# WARN_missing

WARN_missing <- matrix(NA)

for(i in scaff_range) {
  WARN_missing[i] <- sum(subset(get(paste0("scaff",i))[grep("WARN_missing",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  WARN_missing <- WARN_missing[!is.na(WARN_missing)]
}

# FAIL_noADi

FAIL_noADi <- matrix(NA)

for(i in scaff_range) {
  FAIL_noADi[i] <- sum(subset(get(paste0("scaff",i))[grep("FAIL_noADi",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  FAIL_noADi <- FAIL_noADi[!is.na(FAIL_noADi)]
}

# FAIL_FS

FAIL_FS <- matrix(NA)

for(i in scaff_range) {
  FAIL_FS[i] <- sum(subset(get(paste0("scaff",i))[grep("FAIL_FS",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  FAIL_FS <- FAIL_FS[!is.na(FAIL_FS)]
}

# FAIL_noGT

FAIL_noGT <- matrix(NA)

for(i in scaff_range) {
  FAIL_noGT[i] <- sum(subset(get(paste0("scaff",i))[grep("FAIL_noGT",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  FAIL_noGT <- FAIL_noGT[!is.na(FAIL_noGT)]
}

# FAIL_MQ

FAIL_MQ <- matrix(NA)

for(i in scaff_range) {
  FAIL_MQ[i] <- sum(subset(get(paste0("scaff",i))[grep("FAIL_MQ",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  FAIL_MQ <- FAIL_MQ[!is.na(FAIL_MQ)]
}

# FAIL_QD

FAIL_QD <- matrix(NA)

for(i in scaff_range) {
  FAIL_QD[i] <- sum(subset(get(paste0("scaff",i))[grep("FAIL_QD",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  FAIL_QD <- FAIL_QD[!is.na(FAIL_QD)]
}

# FAIL_SOR

FAIL_SOR <- matrix(NA)

for(i in scaff_range) {
  FAIL_SOR[i] <- sum(subset(get(paste0("scaff",i))[grep("FAIL_SOR",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  FAIL_SOR <- FAIL_SOR[!is.na(FAIL_SOR)]
}

# FAIL_ALT

FAIL_ALT <- matrix(NA)

for(i in scaff_range) {
  FAIL_ALT[i] <- sum(subset(get(paste0("scaff",i))[grep("FAIL_ALT",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  FAIL_ALT <- FAIL_ALT[!is.na(FAIL_ALT)]
}

# FAIL_REF

FAIL_REF <- matrix(NA)

for(i in scaff_range) {
  FAIL_REF[i] <- sum(subset(get(paste0("scaff",i))[grep("FAIL_REF",get(paste("scaff",i,sep = ""))$V2),], select = V1))
  FAIL_REF <- FAIL_REF[!is.na(FAIL_REF)]
}

# Create a list of the scaffold names

scaffolds <- 1

for(i in 1:length(scaff_range)) {
  scaffolds[i] <- print(paste0(scaff_range[i], sep=""))
}

# Create new data frame with scaffold and failed filter

filtertable <- data.frame(scaffolds,PASS,WARN_missing,FAIL_DP,FAIL_REF,FAIL_ALT,FAIL_SOR,
                          FAIL_MQ,FAIL_noGT,FAIL_FS,FAIL_noADi,FAIL_QD,FAIL_Rep,FAIL_qual)

View(filtertable)

# Make data long and then calculate percentage

filtertable_perc <- pivot_longer(filtertable,cols = PASS:FAIL_qual, names_to = "filter", values_to = "count") %>%
  group_by(scaffolds) %>%
  mutate(perc = (count / sum(count)) * 100)

write.csv(filtertable_perc,"filterpertest.csv") # take a look at it

# plot

# Had to do this to set palette
nb.cols <- 13
mycolors <- colorRampPalette(brewer.pal(13, "BrBG"))(nb.cols)
mycolors <- mycolors %>% recode("#003C30"="#030706")

# had to do all of this to be able to have barplot be in a specific order
filtertable_PASS <- subset(filtertable_perc, filter %in% "PASS") #doing this to get the preferred order of the plots
filtertable_PASS <- filtertable_PASS[order(filtertable_PASS$perc, decreasing=T),] %>% select(scaffolds)
filtertable_PASS_list <- pull(filtertable_PASS) # get a vector for limits argument for scale_x_discreet

filterplot <- ggplot(filtertable_perc, aes(x=scaffolds,y=perc,fill=filter)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_manual(values = mycolors) +
  theme(axis.text = element_text(angle=90),
        axis.text.x = element_text(vjust = 0,margin = margin(r = 0)),
        panel.background = element_blank()) +
  xlab("Scaffolds") + ylab("Percentage") + labs(fill = "SNP Filter") +
  scale_x_discrete(limits=filtertable_PASS_list) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) # makes the bars go all the way to the axis ticks

ggsave("20230306_SiteFilterTally.tiff",unit="in",height=5,width = 15, dpi=500) # save it bb

# Need a simpler plot with less values. Going to pull out Pass, Warn_missing, Fail_rep, Fail_qual, Fail_DP

filtertable2 <- data.frame(scaffolds,PASS,WARN_missing,FAIL_DP,FAIL_Rep,FAIL_qual)
filtertable_perc2 <- pivot_longer(filtertable2,cols = PASS:FAIL_qual, names_to = "filter", values_to = "count") %>%
  group_by(scaffolds) %>%
  mutate(perc = (count / sum(count)) * 100)

mycolors2 <- c("#824B09","#CEEBE7","#5AB2A8","#005F56","#030706")

filterplot2 <- ggplot(filtertable_perc2, aes(x=scaffolds,y=perc,fill=filter)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_manual(values = mycolors2,
                    labels=c('Fail Depth (> 432x)', 'Fail Quality Score (< 30.0)', 'Repeat Sequence', 'Passing', 'Missing')) +
  theme(axis.text = element_text(angle=90),
        axis.text.x = element_text(vjust = 0,margin = margin(r = 0)),
        panel.background = element_blank()) +
  xlab("Scaffolds") + ylab("Percentage") + labs(fill = "SNP Filter") +
  scale_x_discrete(limits=filtertable_PASS_list) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05)))

ggsave("20230306_SiteFilterTally_simple.tiff",unit="in",height=5,width = 15, dpi=500) # save it bb

