#!/bin/bash
#SBATCH --job-name=AGAT
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8GB
#SBATCH --time=00:10:00
#SBATCH --mail-user=agnieszka.piatkowska@students.unibe.ch
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-11-04

# Directories
WORKDIR=/data/users/apiatkowska/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
OUTDIR=$WORKDIR/output/AGAT
INDIR=$WORKDIR/output/MAKER/final
gff=$INDIR/filtered.genes.renamed.gff3
AGAT_SIF="$COURSEDIR/containers/AGAT_v1.4.1.sif"


cd $OUTDIR

apptainer exec --cleanenv --bind "$COURSEDIR" --bind "$WORKDIR" --pwd "$INDIR" "$AGAT_SIF" \
agat_sp_statistics.pl --gff $gff --output $OUTDIR/annotation.stat