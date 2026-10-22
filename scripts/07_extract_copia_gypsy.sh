#!/bin/bash
#SBATCH --job-name=extract_copia_gypsy
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
R_SIF="$COURSEDIR/containers/Annotation_analysis_R4.4.sif"

cd "$WORKDIR/output/EDTA"
genome=$WORKDIR/output/EDTA/assembly.fasta #  <--  Replace with your assembly filename.

# Extract Copia sequences
apptainer exec -C --bind "$WORKDIR" "$R_SIF" \
    seqkit grep \
    -r \
    -p \
    "Copia" $genome.mod.EDTA.TElib.fa > Copia_sequences.fa

# Extract Gypsy sequences
apptainer exec -C --bind "$WORKDIR" "$R_SIF" \
    seqkit grep \
    -r \
    -p \
    "Gypsy" $genome.mod.EDTA.TElib.fa > Gypsy_sequences.fa