#!/usr/bin/env python

'''make a run script for each subset and output a qsub file'''

qsubfile = open('../qsub.txt','w')
prescript = '02_GWAS_plink_perms_genotyped'
permsetlist = range(1,101)

for permset in permsetlist:
    outfilename = 'run_' + prescript + '_' + str(permset) + '.sh'
    outfile = open(outfilename,'w')
    output = '''#!/bin/bash
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
module load plink\n\n'''


    outfile.write(output)
        
    command = 'time R --no-save < ''' + prescript + '.R --args ' + str(permset) + '\n'
    outfile.write(command)
        
    qsubfile.write('qsub run_scripts/' + outfilename + '\nsleep 3\n')



