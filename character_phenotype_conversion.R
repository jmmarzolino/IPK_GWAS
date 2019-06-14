#!/usr/bin/env Rscript
#SBATCH --job-name=GWAS
#SBATCH -o GWAS_plot.stdout
#SBATCH --ntasks=2
#SBATCH --mem=64gb
#SBATCH -t 2-00:00:00
#SBATCH -p koeniglab

formatted_phenotypes <- read.delim("/bigdata/koeniglab/rkett/row_gwas/results/formatted_phenotypes")

formatted_phenotypes$row_number <- gsub("2-row", 1, formatted_phenotypes$row_number)
formatted_phenotypes$row_number <- gsub("6-row", 0, formatted_phenotypes$row_number)

write.table(formatted_phenotypes,file="formatted_phenotypes_binary",sep="\t", row.names=F,col.names=T)
