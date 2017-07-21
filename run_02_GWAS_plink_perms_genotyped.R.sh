#!/bin/bash
#PBS -N gwas_perm
#PBS -S /bin/bash
#PBS -l walltime=72:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=10gb
#PBS -o logs/${PBS_JOBNAME}.o${PBS_JOBID}.log
#PBS -e logs/${PBS_JOBNAME}.e${PBS_JOBID}.err

cd $PBS_O_WORKDIR

module load gcc/6.2.0
module load R
module load plink

time R --no-save < 02_GWAS_plink_perms_genotyped.R --args 1
