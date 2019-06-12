#!/bin/bash
#SBATCH --job-name=prep_genos
#SBATCH -o std/%j.out
#SBATCH -e std/%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cfisc004@ucr.edu
#SBATCH --ntasks=2
#SBATCH --mem=64gb
#SBATCH -t 2-00:00:00
#SBATCH -p koeniglab

DIR=/rkett/bigdata/row_gwas
mkdir $DIR
# set your VCF file
VCF=Barley_exome_GH_LD_prunded.recode.vcf
# copy VCF file to new project directory
cp $VCF $DIR
# now move to working directory
cd $DIR
module load plink/1.90b3.38
## Filter on MAF and missing data
plink --vcf "$VCF" --maf 0.01 --geno 0.05 --make-bed --out $DIR/filtered


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
