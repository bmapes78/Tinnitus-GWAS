### w/o loops ###
## Paste all files together
echo *ordreg.assoc.dosage | xargs cat > Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt

## Remove ALL file headers
Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22ordreg.assoc.dosage.txt | sed 'x;/Chr*/!g;//!p' > Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage

## Replace first file header
echo 'Chr SNP A1 A2 Value Std..Error t.value OR lCI uCI n P' > temp_file.txt
cat Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt >> temp_file.txt
mv temp_file.txt Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt

## replace chromsome halves (e.g. Chr1.1 -> Chr1) for Chr1-12. note: this can only be done because 'Chr' is the only variable w/ a single decimal place
sed -i -e 's/1.1 /1 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/1.2 /1 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/2.1 /2 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/2.2 /2 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/3.1 /3 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/3.2 /3 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/4.1 /4 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/4.2 /4 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/5.1 /5 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/5.2 /5 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/6.1 /6 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/6.2 /6 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/7.1 /7 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/7.2 /7 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/8.1 /8 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/8.2 /8 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/9.1 /9 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/9.2 /9 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/10.1 /10 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/10.2 /10 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/11.1 /11 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/11.2 /11 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/12.1 /12 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
sed -i -e 's/12.2 /12 /g' Imputed_RIKENcombined1-2_MAF0.01_INFO1.05TINN_age.noise.CumlCispdose.10PCs_chr1-22.ordreg.assoc.dosage.txt
