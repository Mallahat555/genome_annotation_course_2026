#!/bin/bash
#SBATCH --job-name=BUSCO_protein_transcript
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=03:00:00
#SBATCH --mail-user=agnieszka.piatkowska@students.unibe.ch
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-30

module load BUSCO/5.4.2-foss-2021a
export PYTHONNOUSERSITE=1

# Directories
WORKDIR=/data/users/apiatkowska/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
OUTDIR=$WORKDIR/output/BUSCO
INDIR=$WORKDIR/output/MAKER/final

# Renamed, filtered, longest isoforms fasta for proteins and transcript fasta. 
input_protein=$INDIR/assembly.all.maker.proteins.fasta.renamed.fasta.renamed.longest.fasta
input_transcript=$INDIR/assembly.all.maker.transcripts.fasta.renamed.fasta.renamed.longest.fasta

cd "$OUTDIR"

# Run BUSCO on the LONGEST protein and transcript sequences
busco -i "${input_protein}" -l brassicales_odb10 -o busco_proteins -m proteins -c 4
busco -i "${input_transcript}" -l brassicales_odb10 -o busco_transcripts -m transcriptome -c 4
