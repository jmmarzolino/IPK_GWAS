#!/bin/bash
#SBATCH --job-name=GWAS
#SBATCH -o GWAS.stdout
#SBATCH --ntasks=2
#SBATCH --mem=64gb
#SBATCH -t 2-00:00:00
#SBATCH -p koeniglab

cd /rhome/rkett/bigdata/row_gwas

# FORMAT GENOTYPE FILES
VCF=Barley_exome_GH_LD_prunded.recode.vcf
# remove indels from the genotype data because gemma can't handle more than one character per site
module load vcftools
vcftools --vcf $VCF --remove-indels --recode --recode-INFO-all --out formatted_genotypes.vcf
# convert genotype vcf to proper input formats for gemma (ped, bim, fam)
# filter out sites with low minor allele frequencies and more than 5% missing genotypes
module load plink/1.90b3.38
plink --vcf formatted_genotypes.vcf -aec --maf 0.05 --geno 0.05 --make-bed --out formatted_genotypes
# re-order samples so they're in numeric order
sort -d formatted_genotypes.fam

# FORMAT PHENOTYPE FILES
# note: the column numbers must be changed to select different phenotpyes
PHENOS=Phenotype_GWAS
cut -f3 $PHENO > Accession_Codes
cut -f8 $PHENO | cut -f2 --delimiter=\ > phenotype
paste Accession_Codes phenotype > formatted_phenotypes
# use R Script to easily convert character-based phenotypes into simple numerics which will be accepted by gemma
sbatch character_phenotype_conversion.R

# GENERATE P VALUES WITH GENO AND PHENO FILES
# check that IDs in phenos and genos match, make a list of the differences so they can be removed
diff <(cut -d" " -f1 formatted_genotypes.fam) <(cut -f1 formatted_phenotypes_binary | tail -n +2) > diff_samples
grep ">" diff_samples | (cut -f2 --delimiter=\>) > samples_to_remove
# remove incongruent samples from genotype & phenotype file
for line in samples_to_remove; do;
  sed -i".bak" '/${line}/d' formatted_genotypes.fam
  sed -i".bak" '/${line}/d' formatted_phenotypes_binary
done
# no more differences between ID lists, add phenotypes to .fam
paste  <(cut -d" " -f1-5 formatted_genotypes.fam) <(cut -f6 formatted_phenotypes_binary) > formatted_genotypes_phenotypes.tmp
cp formatted_genotypes_phenotypes.tmp formatted_genotypes.fam
# calculate centered relatedness matrix
/rhome/rkett/software/gemma0.98.1 -bfile formatted_genotypes -gk 1 -outdir "results" -o related_matrix
# genotype-phenotype association
/rhome/rkett/software/gemma0.98.1 -bfile formatted_genotypes -k results/related_matrix.cXX.txt -lmm 4 -outdir "results" -o association
