#!/bin/bash
#SBATCH --job-name=BLASTP
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=16GB
#SBATCH --time=00:30:00
#SBATCH --mail-user=agnieszka.piatkowska@students.unibe.ch
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-11-04

set -euo pipefail

# Directories
WORKDIR=/data/users/apiatkowska/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
FINALDIR="$WORKDIR/output/MAKER/final"
PROTEINS="$FINALDIR/assembly.all.maker.proteins.fasta.renamed.fasta.filtered.fasta"
UNIPROT="$COURSEDIR/data/uniprot_viridiplantae_reviewed.fa"
TAIR10="$COURSEDIR/data/TAIR10_pep_20110103_representative_gene_model"
OUTDIR="$WORKDIR/output/comparisons"


mkdir -p "$OUTDIR/tmp"
cd "$OUTDIR"
module load BLAST+/2.15.0-gompi-2021a
# Indexing is necessary before running BLAST using the `makeblastdb` command, but the course directory already
# have indexed reference protein files using the following commands. So you do not need to run these commands
# again.
# makeblastdb -in "$UNIPROT" -dbtype prot
# makeblastdb -in "$TAIR10" -dbtype prot
# Start both searches in parallel.
blastp -query "$PROTEINS" -db "$UNIPROT" -num_threads 10 -outfmt 6 \
-evalue 1e-5 -max_target_seqs 10 -out "$OUTDIR/blastp_uniprot.tsv" &
uniprot_job=$!
blastp -query "$PROTEINS" -db "$TAIR10" -num_threads 10 -outfmt 6 \
-evalue 1e-5 -max_target_seqs 10 -out "$OUTDIR/blastp_TAIR10.tsv" &
tair_job=$!
# Wait for both searches and check that each succeeded.
wait "$uniprot_job"
wait "$tair_job"
# Keep the highest-scoring hit for each query protein.
for reference in uniprot TAIR10; do
sort -k1,1 -k12,12gr -k11,11g "$OUTDIR/blastp_${reference}.tsv" | \
awk -F '\t' '!seen[$1]++' > "$OUTDIR/blastp_${reference}.besthits.tsv"
done