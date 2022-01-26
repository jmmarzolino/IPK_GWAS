#!/bin/bash
#SBATCH --job-name=prep_genos
#SBATCH -o std/%j.stdout
#SBATCH --ntasks=2
#SBATCH --mem=64gb
#SBATCH -t 2-00:00:00
#SBATCH -p koeniglab

module load plink/1.90b3.38
cd $LOCAL
VCF = ${../../data/SNPs/africa_and1001.EVA_filtered.vcf.gz}

## Filter on MAF and missing data  
plink --vcf "$VCF" --maf 0.01 --geno 0.05 --make-bed --out ../../results/gwas/filtered

### OLD CODE BELOW ###
# LD pruning
# identify SNPs to prune
#plink --bfile filtered --indep-pairwise 50 10 0.9 --out ldprune

# extract surviving SNPs 
#plink --bfile filtered --extract ldprune.prune.in --make-bed --out filtered2

