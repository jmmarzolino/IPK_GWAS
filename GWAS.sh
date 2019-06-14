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

# add phenotypes to .fam


# GENERATE P VALUES WITH GENO AND PHENO FILES
# check that IDs in phenos and genos match, make a list of the differences so they can be removed
diff <(cut -d" " -f1 formatted.fam) <(cut -f1 formatted_row_phenotypes | tail -n +2) > samples_to_remove

# remove ERR753224 from genotype file
for line in samples_to_remove: do;
  sed -i".bak" '/"$line"/d' Barley_exome_GH_LD_INDEL_MAF.fam

# no differences between ID lists
paste  <(cut -d" " -f1-5 Barley_exome_GH_LD_INDEL_MAF.fam) <(cut -f6 binary) > Barley_exome_GH_LD_INDEL_MAF.tmp
mv Barley_exome_GH_LD_INDEL_MAF.tmp Barley_exome_GH_LD_INDEL_MAF.fam

# calculate centered relatedness matrix
/rhome/rkett/software/gemma0.98.1 -bfile filtered -gk 1 -outdir "results" -o related_matrix

# association with mlm
/rhome/rkett/software/gemma0.98.1 -bfile Barley_exome_GH_LD_INDEL_MAF -k results/related_matrix_binary.cXX.txt -lmm 4 -outdir results/ -o rows
