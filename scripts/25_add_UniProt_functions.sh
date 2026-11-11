#!/bin/bash
#SBATCH --job-name=add_UniProt_functions
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=16GB
#SBATCH --time=02:00:00
#SBATCH --mail-user=agnieszka.piatkowska@students.unibe.ch
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

# Directories
WORKDIR=/data/users/apiatkowska/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
FINALDIR="$WORKDIR/output/MAKER/final"
PROTEINS="$FINALDIR/assembly.all.maker.proteins.fasta.renamed.fasta.filtered.fasta"
UNIPROT="$COURSEDIR/data/uniprot_renamed/uniprot_viridiplantae_reviewed.fa"
OUTDIR="$WORKDIR/output/comparisons"
MAKER_SIF="$COURSEDIR/containers/MAKER_3.01.03.sif"
GENES="$FINALDIR/filtered.genes.renamed.gff3"


apptainer exec --cleanenv --env TMPDIR=/tmp \
--bind /data --bind "$WORKDIR" --bind "$OUTDIR/tmp":/tmp \
--pwd "$OUTDIR" "$MAKER_SIF" \
maker_functional_fasta "$UNIPROT" "$OUTDIR/blastp_uniprot.besthits.tsv" "$PROTEINS" \
> "$OUTDIR/maker_proteins.filtered.Uniprot.fasta"
apptainer exec --cleanenv --env TMPDIR=/tmp \
--bind /data --bind "$WORKDIR" --bind "$OUTDIR/tmp":/tmp \
--pwd "$OUTDIR" "$MAKER_SIF" \
maker_functional_gff "$UNIPROT" "$OUTDIR/blastp_uniprot.besthits.tsv" "$GENES" \
> "$OUTDIR/filtered.genes.Uniprot.gff3"