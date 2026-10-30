#!/bin/bash
#SBATCH --job-name=InterProScan
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=00:20:00
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
INTERPROSCAN_SIF="$COURSEDIR/containers/InterProScan_5.70.sif"
protein="assembly.all.maker.proteins.fasta"

apptainer exec --cleanenv --pwd "$FINALDIR" \
--bind $COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data \
--bind "$COURSEDIR" --bind "$WORKDIR" \
--bind "$FINALDIR/tmp":/temp \
"$INTERPROSCAN_SIF" \
/opt/interproscan/interproscan.sh \
-appl pfam --disable-precalc -f TSV \
--goterms --iprlookup --seqtype p \
-i ${protein}.renamed.fasta -o output.iprscan