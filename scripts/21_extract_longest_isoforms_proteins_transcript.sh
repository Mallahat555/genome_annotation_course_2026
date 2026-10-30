#!/bin/bash
#SBATCH --job-name=extract_longest_isoforms
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=00:05:00
#SBATCH --mail-user=agnieszka.piatkowska@students.unibe.ch
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-30


# Directories
WORKDIR=/data/users/apiatkowska/genome_annotation_course
COURSEDIR=/data/courses/genome_annotation_resources/2026
OUTDIR=$WORKDIR/output/MAKER
FINALDIR=$OUTDIR/final

protein="$FINALDIR/assembly.all.maker.proteins.fasta.renamed.fasta"
transcript="$FINALDIR/assembly.all.maker.transcripts.fasta.renamed.fasta"

cd $FINALDIR

# Output paths 
protein_out="${protein}.renamed.longest.fasta"
transcript_out="${transcript}.renamed.longest.fasta"

echo "Starting extraction of longest protein isoforms..."

awk '
/^>/ {
    if (seq) {
        if (length(seq) > max_len[gene]) {
            max_len[gene] = length(seq);
            best_header[gene] = prev_header;
            best_seq[gene] = seq;
        }
    }
    prev_header = $0;
    split($1, a, "-R");
    gene = substr(a[1], 2);
    seq = "";
    next;
}
{
    seq = seq $0;
}
END {
    if (seq) {
        if (length(seq) > max_len[gene]) {
            max_len[gene] = length(seq);
            best_header[gene] = prev_header;
            best_seq[gene] = seq;
        }
    }
    for (g in best_header) {
        print best_header[g];
        s = best_seq[g];
        for (i=1; i<=length(s); i+=60) {
            print substr(s, i, 60);
        }
    }
}' "$protein" > "$protein_out"

echo "Extracting longest transcript isoforms..."
awk '
/^>/ {
    if (seq) {
        if (length(seq) > max_len[gene]) {
            max_len[gene] = length(seq);
            best_header[gene] = prev_header;
            best_seq[gene] = seq;
        }
    }
    prev_header = $0;
    split($1, a, "-R");
    gene = substr(a[1], 2);
    seq = "";
    next;
}
{
    seq = seq $0;
}
END {
    if (seq) {
        if (length(seq) > max_len[gene]) {
            max_len[gene] = length(seq);
            best_header[gene] = prev_header;
            best_seq[gene] = seq;
        }
    }
    for (g in best_header) {
        print best_header[g];
        s = best_seq[g];
        for (i=1; i<=length(s); i+=60) {
            print substr(s, i, 60);
        }
    }
}' "$transcript" > "$transcript_out"

echo "Extraction complete!"
