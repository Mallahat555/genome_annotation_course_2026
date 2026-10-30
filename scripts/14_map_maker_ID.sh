#!/bin/bash
#SBATCH --job-name=map_maker_ID
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=8G
#SBATCH --time=00:10:00
#SBATCH --mail-user=agnieszka.piatkowska@students.unibe.ch
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-28

WORKDIR="/data/users/apiatkowska/genome_annotation_course"
OUTDIR="$WORKDIR/output/MAKER"
FINALDIR="$OUTDIR/final"
protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"
gff="assembly.all.maker.noseq.gff"
cd "$FINALDIR"

COURSEDIR=/data/courses/genome_annotation_resources/2026
MAKER_SIF="$COURSEDIR/containers/MAKER_3.01.03.sif"
prefix="PA"  # <-- Replace with your accession prefix/short name. Removed symbols from PA-1

apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
--pwd "$FINALDIR" "$MAKER_SIF" maker_map_ids --prefix $prefix --justify 7 ${gff}.renamed.gff > id.map

apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
--pwd "$FINALDIR" "$MAKER_SIF" map_gff_ids id.map ${gff}.renamed.gff

apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
--pwd "$FINALDIR" "$MAKER_SIF" map_fasta_ids id.map ${protein}.renamed.fasta

apptainer exec --cleanenv --env TMPDIR=/tmp --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
--pwd "$FINALDIR" "$MAKER_SIF" map_fasta_ids id.map ${transcript}.renamed.fasta