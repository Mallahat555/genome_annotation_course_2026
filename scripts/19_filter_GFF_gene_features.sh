#!/bin/bash
#SBATCH --job-name=filter_GFF_features
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
gff=$FINALDIR/assembly.all.maker.noseq.gff_iprscan_quality_filtered.gff


cd $FINALDIR

# We only want to keep gene features and subfeatures in the third column of the gff file
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" \
$gff> filtered.genes.renamed.gff3
sed -i '1i##gff-version 3' filtered.genes.renamed.gff3
# Check
# cut -f3 filtered.genes.renamed.gff3 | sort | uniq