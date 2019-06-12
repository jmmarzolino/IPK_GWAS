#!/bin/bash
#SBATCH --job-name=prep_phenos
#SBATCH -o std/%j.out
#SBATCH -e std/%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cfisc004@ucr.edu
#SBATCH --ntasks=2
#SBATCH --mem=16gb
#SBATCH -t 1-00:00:00
#SBATCH -p batch

# determine which seqs to use as phenotypes 
Rscript 3b_prep_phenotypes.R

# add phenotypes to .fam
PHENOS=../../results/gwas/phenotypes_transformed.txt
GENOS=../../results/gwas/filtered.fam

# check that IDs in phenos and genos match 
DIFS=$(diff <(cut -d" " -f1 "$GENOS") <(cut -f1 "$PHENOS" | tail -n +2) | wc -l)

# no differences between ID lists
if [ "$DIFS" = 0 ]
then
	paste  <(cut -d" " -f1-5 "$GENOS") <(cut -f3- "$PHENOS" | tail -n +2) | sed 's/\t/ /g' > $(basename $GENOS).tmp 
	mv $(basename $GENOS).tmp "$GENOS"
	head -n 1 "$PHENOS" | cut -f3- | sed 's/\t/\n/g' > ../../results/gwas/pheno_lst.txt
fi 

