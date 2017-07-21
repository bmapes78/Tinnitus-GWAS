#!/bin/bash
#PBS -N plink
#PBS -S /bin/bash
#PBS -l walltime=8:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=10gb
#PBS -o logs/${PBS_JOBNAME}.o${PBS_JOBID}.log
#PBS -e logs/${PBS_JOBNAME}.e${PBS_JOBID}.err

cd $PBS_O_WORKDIR
module load gcc/6.2.0
module load plink

plink --bfile /group/dolan-lab/Tinnitus/GWAS/Tinnitus_pilot_GWAS/ARHI_IMPUTED_CLEANED --logistic --maf 0.05 --pheno /group/dolan-lab/Tinnitus/GWAS/Tinnitus_pilot_GWAS/phenoTin.txt --pheno-name tinFT --out /group/dolan-lab/Tinnitus/GWAS/Tinnitus_pilot_GWAS/tinGWAS_noCovar
done
