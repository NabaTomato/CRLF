#############################################################
###### R Script to plot ADMIXTURE results - pophelper #######
#############################################################

# Author: Joey Curti
# Date: FRI AUG 23 2024

## References
# https://www.royfrancis.com/pophelper/articles/#plotting-1

## Dependencies
remotes::install_github('royfrancis/pophelper')
library(pophelper)
library(gridExtra)

## Read data

CV_all <- read.csv(<insert path to file 'Admixture_CV_LLsummary_allsamples_20240619.csv'>,stringsAsFactors = F,sep = ",", header = F)
colnames(CV_all) <- c("k","iteration","cv_error","loglikelihood")

CV_SAMO <- read.csv(<insert path to 'Admixture_CV_LLsummary_unrelated_20240619.csv'>,stringsAsFactors = F,sep = ",", header = F)
colnames(CV_SAMO) <- c("k","iteration","cv_error","loglikelihood")

pp1 <- ggplot(data=CV_all, aes(x=k,y=cv_error)) +
  geom_point() +
  geom_line(aes(group=iteration, color=as.factor(iteration))) +
  theme_pubr() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5)) +
  ylab("CV Score") +
  xlab("K Value") +
  scale_x_continuous(breaks = 1:10) +
  ggtitle("All unrelated samples")

pp2 <- ggplot(data=CV_SAMO, aes(x=k,y=cv_error)) +
  geom_point() +
  geom_line(aes(group=iteration, color=as.factor(iteration))) +
  theme_pubr() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5)) +
  ylab("CV Score") +
  xlab("K Value") +
  scale_x_continuous(breaks = 1:10) +
  ggtitle("Unrelated SAMO samples")


pp3 <- ggarrange(pp1,pp2,labels=c("A","B"))

ggsave(plot=last_plot(),filename = "20240823_CAQU_Admixture_CVplots.png",device = "png",dpi=600, height=5, width = 8)

# K of 1 is best supported, which is the null expectation. Therefore I will highlight K=2 as the next best supported model.


## Read in Q files from all unrelated samples
afiles<- list.files(path=(<insert path to Q files>), pattern = "*allsamples*", full.names=T)
alist <- readQ(files=afiles)

# Get some summaries to make sure you got the right files
tr1 <- tabulateQ(qlist=alist)
sr1 <- summariseQ(tr1)

## Make individual labels for plotting
inds_all = c("LACM107363", "LACM107541", "LACM112287", "CaOr104_I-H10", "CaOr30_I-F03", "CaOr33_I-A04", "CaOr35_I-C04",
                   "CaOr37_II-A01", "CaOr45_I-C05", "CaOr71_II-F01", "CaOr78_II-H01", "CaOr81_II-B02", "CaOr96_I-A10",
                   "T05B038", "T11B098", "T11B111", "T1B050", "T1B052", "T1B054", "T1B075", "T1B081", "T1B082", "T2B001", "T2B029", "T2B060", "T2B084", "T2B085", "T2B086",
                   "T3B024", "T3B032", "T3B066", "T3B091", "T3B092", "T3B109", "T4B004", "T4B009", "T4B057", "T4B073", "T4B074", "T4B096", "T4B110", "T5B093", "T6B055",
                   "T6B067", "T6B107", "T7B013", "T7B036", "T8B041", "T8B070", "T8B094", "T9B090", "WFVZ52698", "WFVZ53206")
inds_all <- cbind(inds_all)

# Add them to Q files -- CAUTION** Make sure you have the correct order from PLINK .fam or .nosex file
if(length(unique(sapply(alist,nrow)))==1) alist <- lapply(alist,"rownames<-",inds_all)

## Make grouping labels for plotting
labs_all <- data.frame(pop_order_all <- c("SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "NORCAL", "NORCAL", "SOCAL", "SOCAL", "SOCAL", "NORCAL", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO",
                   "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO",
                   "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO", "SAMO"))
colnames(labs_all) <- c("Location")

labs_SAMO <- data.frame(pop_order_SAMO <- c("HollywoodRes", "Pallisades", "E_N9", "E_N23", "CorrCyn", "E_SR27", "MonteNido","NORCAL","NORCAL",
                                            "SOCAL","SOCAL","SOCAL","NORCAL","S_US101", "W_MalCyn", "S_US101", "N_US101", "N_US101", "N_US101", "E_MalCyn", "W_I405",
                                            "W_I405", "S_StuntRd", "N_US101", "E_SR27", "W_I405", "W_I405", "W_I405", "N_US101", "N_US101", "N_US101", "E_I405",
                                            "E_I405", "S_US101", "S_StuntRd", "N_US101", "E_SR27", "E_MalCyn", "E_MalCyn", "E_I405", "S_US101", "E_I405",
                                            "E_SR27", "N_US101", "W_MalCyn", "N_US101", "S_US101", "S_US101", "N_US101", "E_I405", "W_I405", "NewburyPark",
                                            "W_N9"))
colnames(labs_SAMO) <- c("Site")

labs_final <- cbind(labs_all,labs_SAMO)

## Create list of Q files for plotting

alist1 <- alignK(alist[c(21,31,41,51,61)]) # I just selected run 1 for the k values I wanted, but change as appropriate

## Get k labels for plotting based on what files you selected

fn1 <- function(x) attr(x,"k")
spnames <- paste0("K=",sapply(alist1,fn1)) # change "alist1" here to get k value labels depending on the number of k you want to visualize

## Plot that sucker!

p1 <- plotQ(alist1,imgoutput="join",returnplot=T,exportplot=F,basesize=30,showindlab=T, useindlab = T,
            ordergrp=T, grplab=labs_final,grplabsize=6,linesize=0.8,pointsize=4,sortind="label",sharedindlab=T, splab=spnames,
            showyaxis=T,indlabangle=75,indlabvjust=1, indlabsize = 10, panelspacer = .4, grplabangle = 70, grplabheight=4,panelratio=c(1,1),
            spbgcol = "lightblue", grplabpos = .5,returndata=T, selgrp="Location")

grid.arrange(p1$plot[[1]])

ggsave(plot=p1$plot[[1]], filename = "step04_CAQU_Admixture_allsamples_20240619.png",device="png",width=20, height = 20, dpi=300)

# Options above:
# imgoutput="join" - plots the k values together
# showindlab=T, useindlab = T - need these options to show the sample names on the plot
# ordergrp=T - needed this to group the grouping labels together, otherwise non-continuous
# grplab=labs_final - this variable contains two grouping labels, can have as many as you want here
# grplabsize=4,linesize=0.8,pointsize=4 - these adjust the size of the grouping labels
# sortind="label",sharedindlab=T - this changes the sorting order of the individuals. You can also sort by cluster (e.g., "Cluster 1" or "Cluster 2").
# if you do this, you cannot have sharedindlab=T, since depending on the k value the order of the individuals might differ. I prefer to keep groupings
# by the grouping labels, but it looks a little cleaner to sort by the cluster
# splab=spnames - this needs to be changed above for other k values. See notes above...
# showyaxis=T - shows y axis
# indlabangle=75,indlabvjust=1, indlabsize = 8, panelspacer = .4, grplabangle = 25, grplabheight=2,panelratio=c(2,1) - this all deals with aesthetics of panel spacing
# and angle of text labels
# spbgcol = "lightblue" - changes color of panel labels on right side
# selgrp="Location" - this sets what group to sort by for sortind="label". Otherwise defaults to top one I think...

# There are a lot more options, see more here:
# https://www.royfrancis.com/pophelper/articles/#plotting-1

## Now do this all over again but for just the SAMO samples

## Read in Q files from all unrelated samples
afiles_SAMO <- list.files(path=(<insert path to Q files>), pattern = "*unrelated*", full.names=T)
alist_SAMO <- readQ(files=afiles_SAMO)

## Make individual labels for plotting
inds_SAMO <- c("LACM107363", "LACM107541", "LACM112287", "CaOr104_I-H10", "CaOr30_I-F03", "CaOr33_I-A04", "CaOr35_I-C04",
             "T05B038", "T11B098", "T11B111", "T1B050", "T1B052", "T1B054", "T1B075", "T1B081", "T1B082", "T2B001", "T2B029", "T2B060", "T2B084", "T2B085", "T2B086",
             "T3B024", "T3B032", "T3B066", "T3B091", "T3B092", "T3B109", "T4B004", "T4B009", "T4B057", "T4B073", "T4B074", "T4B096", "T4B110", "T5B093", "T6B055",
             "T6B067", "T6B107", "T7B013", "T7B036", "T8B041", "T8B070", "T8B094", "T9B090", "WFVZ52698", "WFVZ53206")
inds_SAMO <- cbind(inds_SAMO)


# Add them to Q files -- CAUTION** Make sure you have the correct order from .fam or .nosex file
if(length(unique(sapply(alist_SAMO,nrow)))==1) alist_SAMO <- lapply(alist_SAMO,"rownames<-",inds_SAMO)

labs_SAMO2 <- data.frame(pop_order_SAMO2 <- c("HollywoodRes", "Pallisades", "E_N9", "E_N23", "CorrCyn", "E_SR27", "MonteNido","S_US101", "W_MalCyn", "S_US101", "N_US101",
                                            "N_US101", "N_US101", "E_MalCyn", "W_I405",
                                            "W_I405", "S_StuntRd", "N_US101", "E_SR27", "W_I405", "W_I405", "W_I405", "N_US101", "N_US101", "N_US101", "E_I405",
                                            "E_I405", "S_US101", "S_StuntRd", "N_US101", "E_SR27", "E_MalCyn", "E_MalCyn", "E_I405", "S_US101", "E_I405",
                                            "E_SR27", "N_US101", "W_MalCyn", "N_US101", "S_US101", "S_US101", "N_US101", "E_I405", "W_I405", "NewburyPark",
                                            "W_N9"))
colnames(labs_SAMO2) <- c("Site")

## Create list of Q files for plotting

alist_SAMO_subset <- alignK(alist_SAMO[c(21,31,41,51,61)])

## Get k labels for plotting based on what files you selected

spnames_SAMO <- paste0("K=",sapply(alist_SAMO_subset,fn1))

## Plot that sucker!

p2 <- plotQ(alist_SAMO_subset,imgoutput="join",returnplot=T,exportplot=F,basesize=11,showindlab=T, useindlab = T,
            ordergrp=T, grplab=labs_SAMO2,grplabsize=3.5,linesize=0.8,pointsize=4,sortind="label",sharedindlab=T, splab=spnames_SAMO,
            showyaxis=T,indlabangle=75,indlabvjust=1, indlabsize = 8, panelspacer = .4, grplabangle = 75, grplabheight=2,panelratio=c(1,1),
            spbgcol = "lightblue", grplabpos = .6,returndata=T, selgrp="Site")

grid.arrange(p2$plot[[1]])

ggsave(plot=p2, filename = "step04_CAQU_Admixture_SAMO_20240619.png",device="png",width=10, height = 8)
