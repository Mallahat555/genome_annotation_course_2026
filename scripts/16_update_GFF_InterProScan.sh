#!/bin/bash
#SBATCH --job-name=update_GFF_InterProScan
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --mail-user=agnieszka.piatkowska@students.unibe.ch
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-28

# Directories
WORKDIR=/data/users/apiatkowska/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
OUTDIR=$WORKDIR/output/MAKER
FINALDIR=$OUTDIR/final
MAKER_SIF="$COURSEDIR/containers/MAKER_3.01.03.sif"
gff="assembly.all.maker.noseq.gff"

cd $FINALDIR

apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
--pwd "$FINALDIR" "$MAKER_SIF" ipr_update_gff ${gff}.renamed.gff output.iprscan > ${gff}.renamed.iprscan.gff