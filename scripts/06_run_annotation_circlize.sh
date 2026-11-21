#!/bin/bash
#SBATCH --job-name=R_annotation_circlize
#SBATCH --partition=pshort_el8
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=00:20:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

# Directories
WORKDIR=/data/users/apiatkowska/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026

# R script
R_SCRIPT=$WORKDIR/scripts/06.2_annotation_circlize_improved.R

# Container
R_SIF="$COURSEDIR/containers/Annotation_analysis_R4.4.sif"

cd "$WORKDIR/output/LTR_full_length"

apptainer exec -C --bind "$WORKDIR" --bind "$COURSEDIR" --pwd "$PWD" \
"$R_SIF" \
Rscript --vanilla "$R_SCRIPT"


