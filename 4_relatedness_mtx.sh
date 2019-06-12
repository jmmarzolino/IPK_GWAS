#!/bin/bash
#SBATCH --job-name=calc_mtx
#SBATCH -o std/%j.out
#SBATCH -e std/%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cfisc004@ucr.edu
#SBATCH --ntasks=2
#SBATCH --mem=64gb
#SBATCH -t 1-00:00:00
#SBATCH -p koeniglab

# GEMMA 0.98

# define vars
GENO=../../results/gwas/filtered
OUT=../../results/gwas/<Paste>

# calculate centered relatedness matrix
gemma -bfile "$GENO" -gk 1 -outdir "$OUT" -o related_matrix
