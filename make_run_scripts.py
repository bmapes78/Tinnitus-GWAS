
qsubfile = open('qsub.txt', "w")

for i in range(0,23):
	outfilename = "run_gene_mapping_chr"+str(i)+".sh"
	outfile = open(outfilename,"w")
	bulk = '''#!/bin/bash
#PBS -N Py.map
#PBS -S /bin/bash
#PBS -l walltime=48:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=12gb
#PBS -o logs/${PBS_JOBNAME}.o${PBS_JOBID}.log
#PBS -e logs/${PBS_JOBNAME}.e${PBS_JOBID}.err
cd $PBS_O_WORKDIR

module load gcc/6.2.0
module load python/2.7.6
\n

'''	
