#!/bin/bash
#SBATCH --job-name=R_plot_div
#SBATCH --partition=pshort_el8
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=00:20:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

# Directories
WORKDIR=/data/users/apiatkowska/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
OUTDIR="$WORKDIR/plots/plot_div"

# R script
R_SCRIPT=$WORKDIR/scripts/10_plot_div.R

# Container
R_SIF="$COURSEDIR/containers/Annotation_analysis_R4.4.sif"

cd $OUTDIR

apptainer exec -C --bind "$WORKDIR" --bind "$COURSEDIR" --pwd "$OUTDIR" \
"$R_SIF" \
Rscript --vanilla "$R_SCRIPT"