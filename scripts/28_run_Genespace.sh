#!/bin/bash
#SBATCH --job-name=Genespace
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=64GB
#SBATCH --time=01:00:00
#SBATCH --mail-user=agnieszka.piatkowska@students.unibe.ch
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

set -euo pipefail

WORKDIR=/data/users/apiatkowska/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
GENESPACE_DIR="$WORKDIR/output/genespace/GENESPACE"
GENESPACE_SIF="$COURSEDIR/containers/genespace_latest.sif"

# Use host-backed temporary storage for R's parallel workers.
TMPDIR="$WORKDIR/output/genespace/GENESPACE_R_tmp"

mkdir -p "$TMPDIR"
cd "$WORKDIR"

apptainer exec --cleanenv \
--bind /data --bind "$WORKDIR" \
--bind "$TMPDIR":/temp --env TMPDIR=/temp --pwd "$WORKDIR" \
"$GENESPACE_SIF" Rscript "$WORKDIR/scripts/28_Genespace.R" "$GENESPACE_DIR"