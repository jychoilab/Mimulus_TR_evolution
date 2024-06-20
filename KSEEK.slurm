#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --time=100:00:00
#SBATCH --mem=8GB
#SBATCH --partition=eeb
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err

# FASTQ should be gz

######### Variables to set

# assumes name of the folder corresponds to the sample
FOLDER="/work/eeb/FASTQ/Mlew"

# k-seek scripts
KSEEK=/work/eeb/SCRIPTS/PROGRAMS/k-seek/k_seek.pl

#########

module load perl/5.30

# concat all FASTQ files
zcat "$FOLDER"/*_paired.fastq.gz > "${FOLDER##*/}".fastq

perl "$KSEEK" "${FOLDER##*/}".fastq "${FOLDER##*/}"

rm "${FOLDER##*/}".fastq

