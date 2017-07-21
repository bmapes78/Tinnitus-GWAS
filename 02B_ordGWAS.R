#################################
#### Ordinal Regression GWAS ####
#################################

args <- commandArgs(trailingOnly = T)
"%&%" <- function(a,b) paste(a,b, sep ="")

library(dplyr)
library(MASS) #change to fixed-polr.R to prevent: [Error in optim(s0, fmin, gmin, method = "BFGS", ...) : initial value in 'vmmin' is not finite]

## for testing ##
#chr <- "22"
#phen <- "ord3CIPN8"
#my.dir <- '/Volumes/dolan-lab/Tinnitus/' # hash-out is running on cri
#hw.dir <- '/Volumes/dolan-lab/hwheeler/ThePlatinumStudy/GWAS/' # hash-out is running on cri

chr <- args[1]
phen <- args[2]

my.dir <- '/group/dolan-lab/Tinnitus/' # hash-out if running locally
hw.dir <- '/group/dolan-lab/hwheeler/ThePlatinumStudy/GWAS/'  # hash-out if running locally
geno.dir <- my.dir %&% 'genotype/'
#geno.dir <- "~/Desktop/plink/plink-1.07-mac-intel/" 
res.dir <- my.dir %&% 'GWAS/TinnitusGWASresults/'

source(my.dir %&% "fixed-polr.R")

plateids <- read.table(geno.dir %&% "samples.txt", header = F)
colnames(plateids) = c("FID", "IID")
plateids <- dplyr::select(plateids, FID)
#genofile <- my.dir %&% "test_geno"
genofile <- geno.dir %&% "filt_chr" %&% chr %&% ".dose.vcf.gz"
phenofile <- my.dir %&% 'Formatted_and_ordered_phenocov_tinn.txt'
#covfile <- my.dir %&% 'FormattedData_Omar.txt' #covariates present in phenofile

phenofile <- read.table(phenofile, header = TRUE)
#phenofile$patno <- as.factor(phenofile$patno)
phenofile <- left_join(plateids, phenofile, by = "FID")
#phenocov <- read.table(phenofile, header = T)

cov <- dplyr::filter(phenofile, !is.na(TINN), !is.na(Age), !is.na(CumlCispdose), !is.na(noise)) %>% dplyr::select(FID, Age, noise, CumlCispdose, starts_with("PC")) # get covariates for subset of particpants w/o NA response phenotypes 
#cov <- dplyr::filter(phenofile,   !is.na(CumlCispdose), !is.na(noise), !is.na(Age)) %>% dplyr::select(FID, starts_with("PC"), CumlCispdose, noise, Age)

phenotype <- dplyr::filter(phenofile, !is.na(TINN), !is.na(Age), !is.na(CumlCispdose), !is.na(noise)) %>% dplyr::select(TINN) # remove NAs from phenotype dataframe with dplyr
#phenotype <- dplyr::select(phenofile, TINN)
phenotype <- factor(phenotype[,1]) # ensure phenotype is listed as a factor vector

#List of phenotype NAs to remove from genotype file
to.remove <- phenofile[which(is.na(phenofile$TINN) | is.na(phenofile$Age) | is.na(phenofile$CumlCispdose) | is.na(phenofile$noise)),][1] 
#to.remove <- phenofile[which(is.na(phenofile$TINN)),][1] # create list of NA phenotypes to remove by FID

geno <- read.table(gzfile(genofile), header = F)
geno <- geno[!duplicated(geno$V1),]
# need to remove genotypes that correspoond to phenotypic NAs to create equal sized matrix(dataframe)
#geno <- geno[-(3 + as.numeric(to.remove))] #method wouldn't preserve integrity of data, use anti_join instead
# label genotype dataframe to enable removal of phenotype NAs 
geno.colnames <- as.data.frame(c("SNP", "A1", "A2")) # name header columns
colnames(geno.colnames) <- "FID" # need to name row to facilitate rbind command
#dimensions <- dim(geno)
#write.table(dimension, file = "/group/dolan-lab/Tinnitus/dimensions.geno.txt") # test fields to determine proper dimensions
geno.colnames <- rbind(geno.colnames, plateids) # attatch FIDs to header
colnames(geno) <- as.vector(geno.colnames[,1]) # name geno using appropriate column names
geno <- geno[,is.na(match(colnames(geno), to.remove$FID))] # remove appropriate participants from geno dataframe

rownames(geno) = geno[,"SNP"] # name rows by SNP ID
#geno = head(geno,20) # for testing
bim = geno[,1:3] # create "bim" dataframe # moved up to fascilitate replacement after anti_join of geno and to.remove
geno = geno[,-c(1:3)] # remove "bim" data from geno dataframe
#colnames(bim) <- c("SNP", "A1", "A2") # redundant
bim <- mutate(bim, SNP = as.character(SNP)) # ensure SNP column is a character vector

#### Functions #####
ordreg <- function(gt,pt=phenotype,covariates=covmat){
#ordreg <- function(gt,pt=phenotype){
  m <- polr(pt ~ gt + covariates, Hess=TRUE)
  #m <- polr(pt ~ gt, Hess=TRUE)
  p <- pnorm(abs(summary(m)$coefficients[, "t value"]), lower.tail = FALSE) * 2
  or <- exp(summary(m)$coefficients[,"Value"])
  ci <- exp(confint.default(m))
  colnames(ci) <- c("lCI","uCI")
  n <- m$n
  names(n) <- "n"
  res <- cbind(chr, summary(m)$coefficients[,],"OR"=or,"pval"=p)[1,]
  res <- c(res, ci[1,], n)
  return(res)
}

### run it, Cov: age, noise-exposure, Csiplatin dose, and first 10 principal components
covmat <- dplyr::select(cov, Age, noise, CumlCispdose, starts_with("PC")) # create covariate matrix/dataframe
covmat <- as.matrix(covmat) # characterize covmat as a matrix

ordgwas <- apply(as.matrix(data.matrix(geno)), 1, ordreg) # employ ordinal regression function
tordgwas <- data.frame(t(ordgwas)) %>% dplyr::mutate(SNP = rownames(geno)) %>% dplyr::mutate(P = pval) # transpose output
output <- left_join(bim, tordgwas, by = "SNP") %>% dplyr::select(Chr=chr, SNP, A1, A2, Value:n, P, -pval) # finalize with desired variables
# save final document
write.table(output, file = res.dir %&% "Imputed_RIKENcombined1-2_MAF0.01_INFO1.05" %&% phen %&% "_age.noise.CumlCispdose.10PCs_chr" %&% chr %&% "ordreg.assoc.dosage", quote = F, row.names = F)
