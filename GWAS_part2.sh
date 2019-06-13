#!/bin/bash
#SBATCH --job-name=GWAS
#SBATCH -o GWAS_part2.stdout
#SBATCH --ntasks=2
#SBATCH --mem=64gb
#SBATCH -t 2-00:00:00
#SBATCH -p koeniglab

cd /rhome/rkett/bigdata/row_gwas

module load vcftools
vcftools --vcf Barley_exome_GH_LD_prunded.recode.vcf --remove-indels --recode --recode-INFO-all --out Barley_exome_GH_LD_INDEL.vcf

module load plink/1.90b3.38
plink --vcf Barley_exome_GH_LD_INDEL.vcf --allow-extra-chr 0 --maf 0.01 --geno 0.05 --make-bed --out Barley_exome_GH_LD_INDEL_MAF

/rhome/rkett/software/gemma0.98.1 -g filtered2.recode.geno.txt -p <(cut -f2 formatted_phenotypes2) -k ./results/related_matrix_binary.cXX.txt -lmm 4 -o row_assoc
