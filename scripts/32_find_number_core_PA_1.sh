#!/bin/bash
#SBATCH --job-name=list_core_PA_1_genes
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8GB
#SBATCH --time=00:30:00
#SBATCH --mail-user=agnieszka.piatkowska@students.unibe.ch
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

zcat /data/users/apiatkowska/genome_annotation_course/output/genespace/GENESPACE/pangenes/TAIR10_pangenes.txt.gz | awk '
BEGIN { FS=OFS="\t" }
NR==1 {
    # Find column indices dynamically based on header names
    for (i=1; i<=NF; i++) {
        if ($i == "og") og_col = i;
        if ($i == "genome") genome_col = i;
        if ($i == "gene") gene_col = i;
    }
    next
}
{
    og = $og_col;
    gen = $genome_col;
    # Record which genomes have this orthogroup
    if (!(og in seen_genomes)) {
        seen_genomes[og] = "";
        count[og] = 0;
    }
    # Track unique genomes per orthogroup
    if (index(seen_genomes[og], "," gen ",") == 0) {
        seen_genomes[og] = seen_genomes[og] "," gen ",";
        count[og]++;
    }
    # Store rows for PA_1
    if (gen == "PA_1") {
        pa1_rows[og] = $0;
    }
    total_genomes[gen] = 1;
}
END {
    num_gen = length(total_genomes);
    print "Total genomes detected:", num_gen;
    print "Writing core genes for PA_1...";
    for (og in count) {
        if (count[og] == num_gen && og in pa1_rows) {
            print pa1_rows[og];
        }
    }
}' > PA_1_core_genes.txt