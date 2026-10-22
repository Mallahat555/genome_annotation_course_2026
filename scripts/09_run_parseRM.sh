#!/bin/bash
#SBATCH --job-name=parseRM
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=00:20:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-21
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

# Directories
WORKDIR="/data/users/apiatkowska/genome_annotation_course"
COURSEDIR="/data/courses/genome_annotation_resources/2026"
PERL_SCRIPT="$WORKDIR/scripts/09_parseRM.pl"

# Container
ANNO_SIF="$COURSEDIR/containers/Annotation_analysis_R4.4.sif"

EDTA_DIR="$WORKDIR/output/EDTA/assembly.fasta.mod.EDTA.anno"
genome="$EDTA_DIR/assembly.fasta"

cd "$EDTA_DIR"

awk 'NR == 1 || $2 != 0' "$genome.mod.EDTA.RM.out" > "$genome.mod.EDTA.RM.nonzero.out"

apptainer exec -C --bind "$WORKDIR" --bind "$COURSEDIR" \
    "$ANNO_SIF" \
    perl "$PERL_SCRIPT" -i "$genome.mod.EDTA.RM.nonzero.out" -l 50,1 -v