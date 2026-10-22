#!/bin/bash
#SBATCH --job-name=TEsorter_copia_gypsy
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=00:20:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-21
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

# Directories
WORKDIR=/data/users/apiatkowska/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026

# Container
TESORTER_SIF=$COURSEDIR/containers/TEsorter_1.3.0.sif

# Directories for copia and gypsy
COPIA=$WORKDIR/output/EDTA/Copia_sequences.fa
GYPSY=$WORKDIR/output/EDTA/Gypsy_sequences.fa

cd "$WORKDIR/output/EDTA"

# Rut TEsorter for copia
apptainer exec --bind "$WORKDIR" "$TESORTER_SIF" \
        TEsorter "$COPIA" -db rexdb-plant -p 4

# Rut TEsorter for gypsy
apptainer exec --bind "$WORKDIR" "$TESORTER_SIF" \
        TEsorter "$GYPSY" -db rexdb-plant -p 4