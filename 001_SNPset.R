##
#!/bin/bash -l

#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=20G
#SBATCH --time=2:00:00
#SBATCH --job-name='plink pca'
#SBATCH --output=010_Plink_PCA.stdout
#SBATCH -e %j.err
#SBATCH -p short

#SBATCH --mail-type=ALL
#SBATCH --mail-user=jmarz001@ucr.edu

#Using the FINAL.vcf file that Dan made by imputing genotypes from the genome sequencing, [JBL] first created a SNP set for the 192 lines that were used in the IPK experiment:
vcftools --vcf FINAL.vcf --keep To_Keep.txt --recode --recode-INFO-all --out IPK_SNP_set.vcf
#gives missing proportion of loci for each individual
vcftools --vcf IPK_SNP_set.vcf.recode.vcf --missing-indv

#create a list of individuals with at least 50% missing data
awk '$5 > 0.5' out.imiss | cut -f1 > lowDP50.indv

#observed and expected heterozygosity
vcftools --vcf IPK_SNP_set.vcf.recode.vcf --het

# tested for LD decay using PopLDdecay as I did for the exome panel to see that looked like

# The IPK SNP set was LD pruned with a r2 value of 0.35. The following SNPs were pruned using the below find and replace on the plink.prune.out file:


find: chr(\w+)(\_)(\d+)(\_)(\d+)(\_)(\d+)
replace: chr\1\2\3\4\5\t\7

plink.prune.out.txt

The resulting SNP vcf file consists of 74,231 SNPs for 192 individuals.

/rhome/jlandis/bigdata/RADSeq/IPK/VCFtools/

IPK_LD_pruned_SNPs.recode.vcf

#Missing data ranged from 0 percent (parent lines) to up to 49.1% in one sample from F18
out.imiss.txt

#Heterozygosity values ranged from 36% to 0%, with the parent lines being the 0%.


#####################################
####################################  JM NOTES
# set file references
#INDEX=/rhome/jmarz001/shared/GENOMES/BARLEY/2019_Release_Morex_vers2/Barley_Morex_V2_pseudomolecules.fasta.fai
module load bedtools/2.28.0
