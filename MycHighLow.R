## ----setup, include=FALSE-------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## -------------------------------------------------------------------------------------------------------------------
###install packages
library(dplyr)
library(ggplot2)
args=commandArgs(trailingOnly=TRUE) 


## -------------------------------------------------------------------------------------------------------------------
# Parse arguments (the expected form is --arg=value)
parseArgs <- function(x) strsplit(gsub("^--", "", x), "=")
argsDF <- as.data.frame(do.call("rbind", parseArgs(args)))
arg <- as.list(as.character(argsDF$V2))
names(arg) <- argsDF$V1


## -------------------------------------------------------------------------------------------------------------------
###download data
#test="/sbgenomics/project-files/downsyndrome-gene-counts-rsem-expected_count-collapsed.tsv"
#data<-read.csv(test,sep="\t")
data<-read.csv(args[[1]],sep="\t")

#Put genenames as rownames
rownames(data)<-data$gene_id
data_gene<-data[,-1]

#Check whether data has expression level of gene of interest (ex. MYC) by checking rownames 
#geneofinterest="MYC"
geneofinterest=args[[2]]
data_gene_rows <- rownames(data_gene) == geneofinterest
data_gene_myc<-(data_gene[data_gene_rows, ])


## -------------------------------------------------------------------------------------------------------------------
###Putting label high vs low on MYC expression
data_gene_t<-t(data_gene)
data_gene_t_df<-as.data.frame(data_gene_t)
data_gene_t_df<-data_gene_t_df[order(data_gene_t_df$MYC),]
#Find median of MYC expression
MYC_median<-median(data_gene_t_df$MYC)
#Add a new column "MYCcategory" that patient is assigned with a label ("high" or "low")
data_gene_t_df<-data_gene_t_df %>% mutate(MYCcategory = ifelse(MYC >= MYC_median,"high","low"))
#Return summary of MYC
summary(data_gene_t_df$MYC)
#Bar plots of MYC expression (including ranking based on MYC counts)
plot<-ggplot(data_gene_t_df, aes(x = seq_along(MYC), y = MYC,fill=MYCcategory)) +
  geom_bar(stat = "identity") +
  labs(x = "Patients", y = "MYC counts (in RSEM)", title = "MYC expression of down syndrome patients")
ggsave("/sbgenomics/output-files/GeneMedianSplitted2.pdf")
#pdf("/sbgenomics/output-files/GeneMedianSplitted.pdf")
#print(plot)
dev.off


## -------------------------------------------------------------------------------------------------------------------
###Export csv file of patients with "high" and "low" of gene of interest
#create dataframe of "high" MYC patients
data_gene_t_df_high<-data_gene_t_df[data_gene_t_df$MYCcategory == "high",]
data_Mychigh <- data_gene_t_df_high[, -ncol(data_gene_t_df_high)]
data_Mychigh_t<-t(data_Mychigh)
write.csv(data_Mychigh_t,file=arg[[3]])
#arg[3]="/sbgenomics/output-files/downsyndrome_Mychigh.csv"

#create dataframe of "low" MYC patients
data_gene_t_df_low<-data_gene_t_df[data_gene_t_df$MYCcategory == "low",]
data_Myclow <- data_gene_t_df_low[, -ncol(data_gene_t_df_low)]
data_Myclow_t<-t(data_Myclow)
write.csv(data_Mychigh_t,file=arg[[4]])
#arg[4]="/sbgenomics/output-files/downsyndrome_Myclow.csv")

