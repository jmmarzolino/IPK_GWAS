#!/bin/bash
#SBATCH --job-name=GWAS
#SBATCH -o GWAS_part2.stdout
#SBATCH --ntasks=2
#SBATCH --mem=64gb
#SBATCH -t 2-00:00:00
#SBATCH -p koeniglab

cd /rhome/rkett/bigdata/row_gwas
module load plink/1.90b3.38
module load vcftools

VCF=Barley_exome_GH_LD_prunded.recode.vcf

# format pheotype file
cut -f3 Phenotype_GWAS > Accession_Codes
cut -f8 Phenotype_GWAS > GWAS_Rowx
cut -f2 --delimiter=\  GWAS_Rowx > GWAS_Row2
paste Accession_Codes GWAS_Row2 > formatted_phenotypes
# add phenotypes to .fam

vcftools --vcf Barley_exome_GH_LD_prunded.recode.vcf --remove-indels --recode --recode-INFO-all --out Barley_exome_GH_LD_INDEL.vcf

plink --vcf Barley_exome_GH_LD_INDEL.vcf -aec --maf 0.01 --geno 0.05 --make-bed --out Barley_exome_GH_LD_INDEL_MAF


# check that IDs in phenos and genos match
diff <(cut -d" " -f1 Barley_exome_GH_LD_INDEL_MAF.fam) <(cut -f1 formatted_phenotypes2 | tail -n +2
# remove ERR753224 from genotype file

# no differences between ID lists
paste  <(cut -d" " -f1-5 Barley_exome_GH_LD_INDEL_MAF.fam) <(cut -f6 binary) > Barley_exome_GH_LD_INDEL_MAF.tmp
mv Barley_exome_GH_LD_INDEL_MAF.tmp Barley_exome_GH_LD_INDEL_MAF.fam

# calculate centered relatedness matrix
/rhome/rkett/software/gemma0.98.1 -bfile filtered -gk 1 -outdir "results" -o related_matrix

# association with mlm
/rhome/rkett/software/gemma0.98.1 -bfile Barley_exome_GH_LD_INDEL_MAF -k results/related_matrix_binary.cXX.txt -lmm 4 -outdir results/ -o rows
