#!/bin/bash
#SBATCH --job-name=map_pgIDs_all_flags
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8GB
#SBATCH --time=00:10:00
#SBATCH --mail-user=agnieszka.piatkowska@students.unibe.ch
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

WORKDIR=/data/users/apiatkowska/genome_annotation_course
PANGENES="$WORKDIR/output/genespace/GENESPACE/pangenes/TAIR10_pangenes.txt.gz"
GFF="$WORKDIR/output/comparisons/filtered.genes.Uniprot.gff3"
OUTDIR="$WORKDIR/output/extra_analysis"

mkdir -p "$OUTDIR"
mkdir -p "$WORKDIR/logs"
cd "$OUTDIR"

# 1. Create a temporary file containing your target pgIDs
TARGETS="target_ids.txt"
cat << 'EOF' > "$TARGETS"
29585
30657
3343
3351
1035
11632
23253
30209
31318
1345
3817
7493
9187
9188
9191
9192
9297
9439
21947
21965
EOF

# 2. Single-pass awk script to parse GFF3, ingest all PASS and NSOrtho PA_1 matches, and output the labeled table
awk -v tgt="$TARGETS" '
BEGIN {
    FS=OFS="\t";
    # Load targets in original order
    while ((getline < tgt) > 0) {
        t = $1;
        if (!(t in target_set)) {
            order[++n] = t;
            target_set[t] = 1;
        }
    }
    close(tgt);
}

# PASS 1: Read GFF3 file to store gene functional descriptions
NR==FNR {
    if ($3 == "gene") {
        attrs = $9;
        if (match(attrs, /ID=([^;]+)/, arr)) {
            gid = arr[1];
            d = "No annotation found";
            if (match(attrs, /Note=([^;]+)/, n_arr)) {
                d = n_arr[1];
            }
            gff_desc[gid] = d;
        }
    }
    next
}

# PASS 2: Read Pangenome file (streamed via zcat)
NR == FNR+1 || $0 ~ /pgID/ {
    for (i=1; i<=NF; i++) {
        if ($i == "pgID") pgid_col = i;
        if ($i == "genome") gen_col = i;
        if ($i == "flag") flag_col = i;
        if ($i == "id") id_col = i;
    }
    next
}

pgid_col && $0 !~ /^#/ {
    pg_val = $pgid_col;
    if (pg_val in target_set && $gen_col == "PA_1" && ($flag_col == "PASS" || $flag_col == "NSOrtho")) {
        gid = $id_col;
        flg = $flag_col;
        
        # Avoid duplicate identical rows if any exist in the pangenome table
        match_key = pg_val SUBSEP gid SUBSEP flg;
        if (!(match_key in seen)) {
            seen[match_key] = 1;
            match_count[pg_val]++;
            matches[pg_val, match_count[pg_val]] = gid FS flg;
        }
    }
}

END {
    # Print table header
    print "pgID", "PA_Gene_ID", "Flag", "Function";
    
    # Iterate through original input order
    for (i=1; i<=n; i++) {
        pgid = order[i];
        if (match_count[pgid] > 0) {
            for (j=1; j<=match_count[pgid]; j++) {
                split(matches[pgid, j], parts, FS);
                gid = parts[1];
                flg = parts[2];
                desc = (gid in gff_desc) ? gff_desc[gid] : "No annotation found";
                print pgid, gid, flg, desc;
            }
        } else {
            print pgid, "NA", "None", "No PA_1 PASS or NSOrtho gene found";
        }
    }
}' "$GFF" <(zcat "$PANGENES") > "$OUTDIR/target_genes_functions.tsv"

echo "Done! Output saved to $OUTDIR/target_genes_functions.tsv"
rm -f "$TARGETS"