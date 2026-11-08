#!/bin/bash
#SBATCH --job-name=Genespace_data_prep
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=64GB
#SBATCH --time=00:05:00
#SBATCH --mail-user=agnieszka.piatkowska@students.unibe.ch
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

# Directories 
WORKDIR=/data/users/apiatkowska/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
OUTDIR="$WORKDIR/output/genespace"
GENESPACE_DIR="$OUTDIR/GENESPACE"

Accession=PA_1
FINALDIR="$WORKDIR/output/MAKER/final"

# create directories
mkdir -p "$GENESPACE_DIR/bed" "$GENESPACE_DIR/peptide" "$GENESPACE_DIR/tmp"

# INPUT DIRECTORIES

# Maker input:
GENES="$FINALDIR/filtered.genes.renamed.gff3"
# Input longest protein isoform for Pa-1 accession:
LONGEST_PROTEINS="$FINALDIR/assembly.all.maker.proteins.fasta.renamed.fasta.renamed.longest.fasta"

# 1. Extract gene coordinates from your filtered GFF3
grep -P "\tgene\t" "$GENES" > "$GENESPACE_DIR/temp_genes.gff3"
# Get the the first attribute in column 9 which is ID=gene_name.
awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' \
"$GENESPACE_DIR/temp_genes.gff3" > "$GENESPACE_DIR/bed/${Accession}.bed"

# 2. Remove transcript suffixes and descriptions from FASTA headers.
sed '/^>/s/ .*//' "$LONGEST_PROTEINS" | sed '/^>/s/-R[A-Z]*$//' \
> "$GENESPACE_DIR/peptide/${Accession}.fa"

# 3. Copy TAIR10 reference genome
cp "$COURSEDIR/data/TAIR10.bed" "$GENESPACE_DIR/bed/TAIR10.bed"
cp "$COURSEDIR/data/TAIR10.fa" "$GENESPACE_DIR/peptide/TAIR10.fa"

# 4. Copy other accessions
other_1=Etna_2
cp "$COURSEDIR/data/Lian_et_al/GENESPACE/bed/${other_1}.bed" \
"$GENESPACE_DIR/bed/${other_1}.bed"
cp "$COURSEDIR/data/Lian_et_al/GENESPACE/peptide/${other_1}.fa" \
"$GENESPACE_DIR/peptide/${other_1}.fa"

other_2=Altai_5
cp "$COURSEDIR/data/Lian_et_al/GENESPACE/bed/${other_2}.bed" \
"$GENESPACE_DIR/bed/${other_2}.bed"
cp "$COURSEDIR/data/Lian_et_al/GENESPACE/peptide/${other_2}.fa" \
"$GENESPACE_DIR/peptide/${other_2}.fa"

other_3=Are_6
cp "$COURSEDIR/data/Lian_et_al/GENESPACE/bed/${other_3}.bed" \
"$GENESPACE_DIR/bed/${other_3}.bed"
cp "$COURSEDIR/data/Lian_et_al/GENESPACE/peptide/${other_3}.fa" \
"$GENESPACE_DIR/peptide/${other_3}.fa"

echo "GENESPACE inputs prepared successfully in $GENESPACE_DIR"

