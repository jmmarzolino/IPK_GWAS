#!/bin/bash
#SBATCH --job-name=GWAS
#SBATCH -o GWAS.stdout
#SBATCH --ntasks=2
#SBATCH --mem=64gb
#SBATCH -t 2-00:00:00
#SBATCH -p koeniglab

DIR=/rhome/rkett/bigdata/row_gwas
cd $DIR
# set your VCF file
VCF=Barley_exome_GH_LD_prunded.recode.vcf
module load plink/1.90b3.38
## Filter on MAF and missing data
plink --vcf "$VCF" --allow-extra-chr --maf 0.01 --geno 0.05 --make-bed --out $DIR/filtered


# format pheotype file
cut -f3 Phenotype_GWAS > Accession_Codes
cut -f8 Phenotype_GWAS > GWAS_Rowx
cut -f2 --delimiter=\  GWAS_Rowx > GWAS_Row2
paste Accession_Codes GWAS_Row2 > formatted_phenotypes
# add phenotypes to .fam

#!/bin/bash
#SBATCH --job-name=GWAS
#SBATCH -o GWAS.stdout
#SBATCH --ntasks=2
#SBATCH --mem=64gb
#SBATCH -t 2-00:00:00
#SBATCH -p koeniglab

DIR=/rhome/rkett/bigdata/row_gwas
cd $DIR
GENOS=filtered2.fam
PHENOS=formatted_phenotypes2

# check that IDs in phenos and genos match
DIFS=$(diff <(cut -d" " -f1 "$GENOS") <(cut -f1 "$PHENOS" | tail -n +2) | wc -l)
# delete non-common entries:  ERR753224 from genotype data & ERR753318 from phenotype data

# no differences between ID lists
if [ "$DIFS" = 0 ]
then
	paste  <(cut -d" " -f1-5 "$GENOS") <(cut -f3- "$PHENOS" | tail -n +2) | sed 's/\t/ /g' > $(basename $GENOS)
fi
