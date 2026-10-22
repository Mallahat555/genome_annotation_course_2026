#!/bin/bash
#SBATCH --job-name=sam_faidx
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
CONTAINER=$COURSEDIR/containers/Annotation_analysis_R4.4.sif
ASSEMBLY_FA=$WORKDIR/data/assembly.fasta

# output is generated in $WORKDIR/data/ LOL:)
cd "$WORKDIR/output/LTR_full_length"

apptainer exec -C --bind "$WORKDIR" "$CONTAINER" \
    samtools faidx "$ASSEMBLY_FA"