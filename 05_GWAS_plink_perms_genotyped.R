##############################################################################
## GWAS permutations                                                        ##
## by: Brandon Mapes                                                        ##
## adapted from Omar El-Charif, taken from Dr. Heather Wheeler 03/17/2016   ##
## shuffle phenotypes and rerun GWAS n times                                ##
## output matrix of numSNPs x nPerms                                        ##
##############################################################################

args <- commandArgs(trailingOnly=T)
"%&%" <- function(a,b) paste(a,b,sep="")
date <- Sys.Date()
library(dplyr)


###directories
hw.dir <- "/group/dolan-lab/hwheeler/ThePlatinumStudy/GWAS/"
my.dir <- "/group/dolan-lab/oelcharif/ThePlatinumStudy/Ototoxicity/tinn/"

#dos.dir <- hw.dir %&% "genotypes/UMich_imputation_results/mach_dosage_files/"
gt.dir <- hw.dir %&% 'genotypes/'
gwas.dir <- "/group/dolan-lab/Tinnitus/GWAS/TinnitusGWASresults/"
pt.dir <- gwas.dir %&% "perm/phenotypes/"
perm.dir <- gwas.dir %&% "perm/permutations/"

permset <- args[1]
###num perms
n = 10
phenotype <- "biTINN_plink"
covariates <- "Age,CumlCispdose,noise,PC1-PC10"
covtag <- "Age.CumlCispdose.noise.10PCs"

###read in phenotypes and covariates
pheno <- read.table(pt.dir %&% "Tinnitus.phenofile", header = T, stringsAsFactors = F)
###pull FID, IID, and PCs, which will remain connected to genotypes
phenofixed <- dplyr::select(pheno, FID, IID, starts_with("PC"))
#pheno2shuffle <- dplyr::filter(pheno, biRAYN_ex != -9, !is.na(CumlBLEOdose)) %>% dplyr::select(FID, biRAYN_ex, CumlBLEOdose, PC1)

pheno2shuffle <- dplyr::filter(pheno, biTINN_plink != -9, !is.na(Age), !is.na(CumlCispdose), !is.na(noise)) %>% dplyr::select(FID, biTINN_plink, Age, CumlCispdose, noise, starts_with("PC"))

resdfwhole <- read.table(gt.dir %&% "N88_F13.postQC.frq", header = T, stringsAsFactors = F)
resdf <- resdfwhole %>% dplyr::select(SNP)
colnames(resdf) <- "SNP"
resdf[,1] <- as.character(resdf[,1]) 
rm(resdfwhole)

for(i in c(1:n)){
  ###shuffle pheno & connect phenoperm to the wrong FID for merging with PCs
  phenoperm <- dplyr::sample_n(pheno2shuffle[,2:5], size = dim(pheno2shuffle)[1]) %>% mutate(FID = pheno2shuffle[,1])
  newpheno <- left_join(phenofixed, phenoperm, by = "FID")
  newpheno$biTINN_plink <- ifelse(is.na(newpheno$biTINN_plink), -9, newpheno$biTINN_plink)
  write.table(newpheno, "tmp.pheno." %&% permset, quote = F, row.names = F)
  ###run gwas
  runPLINK <- "plink --bfile " %&% gt.dir %&% "N88_F13.postQC --logistic --maf 0.05 --pheno tmp.pheno." %&%
    permset %&% " --pheno-name " %&% phenotype %&% " --covar tmp.pheno." %&% permset %&% " --covar-name " %&% covariates %&% " --out tmp.plink." %&% permset  
  pullADD <- "grep ADD tmp.plink." %&% permset %&% ".assoc.logistic > tmp.gwas.permset" %&% permset
  
  system(runPLINK)
  system(pullADD)
  
  singleres <- read.table("tmp.gwas.permset" %&% permset, stringsAsFactors = F) 
  singleres <- as.data.frame(cbind(as.character(singleres[,2]), singleres[,9]))
  colnames(singleres) <- c("SNP", "P")
  ###add p-values to resdf
  resdf <- inner_join(resdf, singleres, by = "SNP")
  colnames(resdf)[ncol(resdf)] <- c("P" %&% i)
  
  #singlereslong <- read.table("tmp.gwas.permset" %&% permset, header=T) #%>% dplyr::select(P)
  #colnames(singleres) <- c("P" %&% i)
  #singlereslong <- read.table(perm.dir %&% "tmp.gwas.permset" %&% permset, header=F, stringsAsFactors = F)
  #colnames(singlereslong) = c("CHR", "SNP", "BP", "A1", "TEST", "NMISS", "OR", "STAT", "P")
  #singleres <- singlereslong %>% dplyr::select(P)
  #colnames(singleres) <- c("P" %&% i)
  ###add p-values to resdf
  #if(identical(singlereslong$SNP, resdf$SNP)){
  #  resdf <- cbind(resdf, singleres)
  #}else{stop("Nonmatching SNPs")}
}

write.table(resdf, perm.dir %&% "N88_F13_genotyped_" %&% phenotype %&% "_" %&% covtag %&% "_" %&% n %&% "perms_set" %&% permset %&% ".txt", quote=F, row.names=F)