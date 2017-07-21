#!/bin/bash
#PBS -N R.gcta
#PBS -S /bin/bash
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=10gb
#PBS -o logs/${PBS_JOBNAME}.o${PBS_JOBID}.log
#PBS -e logs/${PBS_JOBNAME}.e${PBS_JOBID}.err

cd $PBS_O_WORKDIR
module load gcc/6.2.0
module load gcta


gcta --bfile /group/dolan-lab/hwheeler/ThePlatinumStudy/GWAS/genotypes/N88_F13.postQC --autosome --make-grm-bin --out /group/dolan-lab/Tinnitus/GCTA/N88_F13_genotyped_TinnBin.postQC

##combine chr grms

gcta --reml --grm-bin /group/dolan-lab/Tinnitus/GCTA/N88_F13_genotyped_TinnBin.postQC --pheno /group/dolan-lab/Tinnitus/GCTA/Tinn.phenofile_forGCTA --out /group/dolan-lab/Tinnitus/GCTA/N88_F13.Tinnitus_GCTA_AgeNoisCumlCis.1PC.genotyped --qcovar /group/dolan-lab/Tinnitus/GCTA/Tinn.covfile_forGCTA --grm-cutoff 0.025
