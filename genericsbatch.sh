#!/bin/bash -l
#SBATCH -J generic_reg
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80G
#SBATCH -t 6:00:00
#SBATCH -p msismall
#SBATCH -o output_logs/generic_%A_%a.out
#SBATCH -e output_logs/generic_%A_%a.err
#SBATCH -A rando149

/bin/bash -c "$@"