#!/bin/bash
#SBATCH --job-name=extract_mRNA_after_filtering
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
ANALYSIS_SIF="$COURSEDIR/containers/Annotation_analysis_R4.4.sif"

protein="$FINALDIR/assembly.all.maker.proteins.fasta.renamed.fasta"
transcript="$FINALDIR/assembly.all.maker.transcripts.fasta.renamed.fasta"
gff="$FINALDIR/filtered.genes.renamed.gff3"

cd $FINALDIR

grep -P "\tmRNA\t" $gff | awk '{print $9}' | cut -d ';' -f1 | sed 's/ID=//g' > list.txt

apptainer exec --cleanenv --bind "$COURSEDIR" --bind "$WORKDIR" --pwd "$FINALDIR" "$ANALYSIS_SIF" seqkit grep \
-f list.txt $transcript -o ${transcript}.filtered.fasta

apptainer exec --cleanenv --bind "$COURSEDIR" --bind "$WORKDIR" --pwd "$FINALDIR" "$ANALYSIS_SIF" seqkit grep \
-f list.txt $protein -o ${protein}.filtered.fasta