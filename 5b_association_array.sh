#!/bin/bash
#SBATCH --job-name=gwas
#SBATCH -o std/%j.out
#SBATCH -e std/%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cfisc004@ucr.edu
#SBATCH --ntasks=2
#SBATCH --mem=16gb
#SBATCH -t 1-00:00:00
#SBATCH -p koeniglab
#SBATCH --array=1-1

# GEMMA 0.98

# define variables 
GENO=../../results/gwas/filtered 
KINSHIP=../../results/gwas/output/related_matrix.cXX.txt
PHENO_NAME=$(head -n "$SLURM_ARRAY_TASK_ID" ../../results/gwas/pheno_lst.txt | tail -n 1)
COL=$(($SLURM_ARRAY_TASK_ID))
OUT=../../results/gwas/

# association with mlm
gemma -bfile "$GENO" -n "$COL" -k $KINSHIP -lmm 4 -outdir "$OUT" -o $PHENO_NAME
