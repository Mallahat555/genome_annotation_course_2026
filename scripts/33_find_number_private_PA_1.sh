#!/bin/bash
#SBATCH --job-name=list_private_PA_1_genes
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
    for (i=1; i<=NF; i++) {
        if ($i == "og") og_col = i;
        if ($i == "genome") genome_col = i;
    }
    next
}
{
    og = $og_col;
    gen = $genome_col;
    # Track how many times / which genomes have this og
    og_count[og]++;
    og_genome[og] = gen;
    if (gen == "PA_1") {
        pa1_rows[og] = $0;
    }
}
END {
    print "Writing accession-specific genes for PA_1...";
    for (og in og_count) {
        if (og_count[og] == 1 && og_genome[og] == "PA_1" && og in pa1_rows) {
            print pa1_rows[og];
        }
    }
}' > PA_1_private_genes.txt