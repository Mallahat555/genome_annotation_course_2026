#!/bin/bash
#SBATCH --job-name=Pangenome_process
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8GB
#SBATCH --time=00:30:00
#SBATCH --mail-user=agnieszka.piatkowska@students.unibe.ch
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

WORKDIR=/data/users/apiatkowska/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
ANALYSIS_SIF="$COURSEDIR/containers/Annotation_analysis_R4.4.sif"
TMPDIR="$WORKDIR/output/comparisons/Annotation_R_tmp"

mkdir -p "$TMPDIR"

apptainer exec --cleanenv \
--bind /data --bind "$WORKDIR" \
--bind "$TMPDIR":/temp --env TMPDIR=/temp --pwd "$WORKDIR" \
"$ANALYSIS_SIF" Rscript "$WORKDIR/scripts/29_process_pangenome.R"