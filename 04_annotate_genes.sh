#!/bin/bash
#PBS -N Py.annotate
#PBS -S /bin/bash
#PBS -l walltime=72:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=12gb
#PBS -o logs/${PBS_JOBNAME}.o${PBS_JOBID}.log
#PBS -e logs/${PBS_JOBNAME}.e${PBS_JOBID}.err

cd $PBS_O_WORKDIR

module load python/2.7.6

#python /group/dolan-lab/oelcharif/map_genes_to_p.py --gwasfile /group/dolan-lab/oelcharif/ThePlatinumStudy/RAYN/GWASresults/Imputed_RIKENcombined1-2_MAF0.01_INFO1.05maxRAYN_CumlBLEOdose.10PCs_chr1-22.ordreg.assoc.dosage.sorted --dist 20 --out /group/dolan-lab/oelcharif/ThePlatinumStudy/RAYN/Annotated_genes_maxRAYN_MAF0.01_INFO1.05_CumlBLEOdose.10PCs --tarbell True

python /group/dolan-lab/oelcharif/map_genes_to_p.py --gwasfile /group/dolan-lab/Tinnitus/GWAS/TinnitusGWASresults/Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt --dist 20 --out /group/dolan-lab/Tinnitus/GWAS/TinnitusGWASresults/Annotated_genes_TINN_age.noise.CumlCispdose.10PCs_ordreg --tarbell False --gardner True
