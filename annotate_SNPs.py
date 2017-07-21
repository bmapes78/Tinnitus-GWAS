
gwasfile = "/group/dolan-lab/Tinnitus/GWAS/TinnitusGWASresults/Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt"

gwas = dict()
for line in open(gwasfile):
	linelist = line.strip().split()
	(chr, snp, bp) = linelist[0:3]
	cleanline = linelist[0:5] + linelist[8:11] + [linelist[12]]
	if chr not in gwas:
		gwas[chr] = dict()
	gwas[chr][bp] = ' '.join(cleanline)

referencefile = "/group/dolan-lab/hwheeler/ThePlatinumStudy/GWAS/deafness_genes/gencode.v18.genes.patched_contigs.summary.protein"
outfilename = "/group/dolan-lab/Tinnitus/GWAS/TinnitusGWASresults/Annotated_genes_TINN_age.noise.CumlCispdose.10PCs_ordreg_20kb"
outfile = open(outfilename, "w")

outfile.write('gene ensid chr start end CHR SNP BP A1 A2 OR lCI uCI P\n')

for line in open(referencefile):
	linelist = line.strip().split()
	(chrom, strand, start, end, ensid, gene, pc, k) = linelist
	c = chrom.split('r')[1]
	if c in gwas:
		poslist = gwas[c].keys()
		for pos in poslist:
			if int(pos) > (int(start)-20000) and int(pos) < (int(end) + 20000):
				gwasres = gwas[c][pos]
				outstring = gene + ' ' + ensid + ' ' + chrom + ' '+ start+' '+end+' '+gwasres + '\n'
				outfile.write(outstring)

outfile.close()
