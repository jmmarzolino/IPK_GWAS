#!/bin/bash
#SBATCH --job-name=assoc
#SBATCH -o std/%j.out
#SBATCH -e std/%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cfisc004@ucr.edu
#SBATCH --ntasks=4
#SBATCH --mem=64gb
#SBATCH -t 7-00:00:00
#SBATCH -p koeniglab
#SBATCH --array=1-231%10

# working directory 
cd ../../results/gwas 

# GEMMA 0.98

# gwa with mlm  
gemma -g genotypes.txt -p <(cut -f1 phenotypes.txt) -k ./output/related_matrix.cXX.txt -lmm 4 -o PC1_assoc 
