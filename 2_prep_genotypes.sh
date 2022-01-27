#!/bin/bash
#SBATCH --job-name=prep_genos
#SBATCH -o std/%j.stdout
#SBATCH --ntasks=2
#SBATCH --mem=64gb
#SBATCH -t 2-00:00:00
#SBATCH -p koeniglab

# set directories
PROJECT_DIR=/rhome/jmarz001/bigdata/IPK_Analysis/results/GWAS/
cd $PROJECT_DIR

#plink 2.0 is not yet fully usable on its own so use 1.90
module load plink/1.90b3.38

## Filter on MAF and missing data  
plink --vcf "$VCF" --maf 0.01 --geno 0.05 --make-bed --out ../../results/gwas/filtered
# all the sequencing files (separated and parsed?) are listed here
#/rhome/jmarz001/shared/SEQ_RUNS/FULL_RAD_RECORDS/RECORDS.txt

# The resulting SNP vcf file consists of 74,231 SNPs for 192 individuals.
# was LD pruned, but other filters unknown, may have been applied to JBLs input: FINAL.vcf which was filtered by Dan?
VCF=/rhome/jlandis/bigdata/RADSeq/IPK/VCFtools/IPK_LD_pruned_SNPs.recode.vcf
# another file in the dir, just progeny?
# IPK_SNP_set_progeny.vcf.recode.vcf.gz


