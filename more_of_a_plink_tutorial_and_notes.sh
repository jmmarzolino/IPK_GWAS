#plink 2.0 is not yet fully usable on its own so use 1.90
module load plink/1.90b3.38


plink --bfile filtered2 --pca 10 var-wts -out pca

# convert to plink binary formats
plink --file text_fileset --out binary_fileset
# convert to plink binary after filtering
plink --file text_fileset --maf 0.05 --make-bed --out binary_fileset
# allele frequency reports
plink --file text_fileset --freq --out results


###Distance matrices
##Identity-by-state/Hamming
--distance [{square | square0 | triangle}] [{gz | bin | bin4}] ['ibs'] ['1-ibs'] ['allele-ct'] ['flat-missing']
--distance-wts exp=<x>
--distance-wts <filename> ['noheader']
##Relationship/covariance
--make-rel [{square | square0 | triangle}] [{gz | bin | bin4}] [{cov | ibc2 | ibc3}]


‐‐bfile {your_file} for binary files (as input)
 method that is incorporated in PLINK: the multidimensional scaling (MDS) approach


 Irregularly-formatted PLINK text files
 --no-fid
 --no-parents
 --no-sex
 --no-pheno

 --vcf <filename>
 --vcf loads a (possibly gzipped) VCF file, extracting information which can be represented by the PLINK 1 binary format and ignoring everything else (after applying the load filters described below).
 PLINK 1.9 normally forces major alleles to A2 during its loading sequence. One workaround is permanently keeping the .bim file generated during initial conversion, for use as --a2-allele input whenever the reference sequence needs to be recovered. (If you use this method, note that, when your initial conversion step invokes --make-bed instead of just --out, you also need --keep-allele-order to avoid losing track of reference alleles before the very first write, because --make-bed triggers the regular loading sequence.)
