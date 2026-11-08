#!/bin/bash
#SBATCH --job-name=ID_check
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

BED="/data/users/apiatkowska/genome_annotation_course/output/genespace/GENESPACE/bed/PA_1.bed"
FASTA="/data/users/apiatkowska/genome_annotation_course/output/genespace/GENESPACE/peptide/PA_1_fixed.fa"

# Updated to use the target directory with an absolute path
REPORT="/data/users/apiatkowska/genome_annotation_course/output/genespace/GENESPACE/validation_report_fixed.txt"

# Temporary files (created in the current working directory where the job runs)
BED_IDS="bed_ids.tmp"
FASTA_IDS="fasta_ids.tmp"
BED_DUPS="bed_dups.tmp"
FASTA_DUPS="fasta_dups.tmp"

# 1. Extract IDs
awk '{if (NF >= 4) print $4}' "$BED" | sort > "$BED_IDS"
grep '^>' "$FASTA" | tr -d '>' | awk '{print $1}' | sort > "$FASTA_IDS"

# 2. Compute metrics
TOTAL_BED=$(wc -l < "$BED_IDS")
UNIQUE_BED=$(sort -u "$BED_IDS" | wc -l)
TOTAL_FASTA=$(wc -l < "$FASTA_IDS")
UNIQUE_FASTA=$(sort -u "$FASTA_IDS" | wc -l)

uniq -d "$BED_IDS" > "$BED_DUPS"
uniq -d "$FASTA_IDS" > "$FASTA_DUPS"
DUPS_BED_COUNT=$(wc -l < "$BED_DUPS")
DUPS_FASTA_COUNT=$(wc -l < "$FASTA_DUPS")

# Differences using comm
comm -23 "$FASTA_IDS" "$BED_IDS" > missing_in_bed.tmp
comm -13 "$FASTA_IDS" "$BED_IDS" > extra_in_bed.tmp
MISSING_COUNT=$(wc -l < missing_in_bed.tmp)
EXTRA_COUNT=$(wc -l < extra_in_bed.tmp)
TOTAL_DIFFERENCES=$((MISSING_COUNT + EXTRA_COUNT))

# 3. Generate the Text Report
{
    echo "=================================================="
    echo "            GENESPACE ID VALIDATION REPORT        "
    echo "=================================================="
    echo "BED File:   $BED"
    echo "FASTA File: $FASTA"
    echo "--------------------------------------------------"
    echo "Total Records in BED:       $TOTAL_BED (Unique: $UNIQUE_BED)"
    echo "Total Records in FASTA:     $TOTAL_FASTA (Unique: $UNIQUE_FASTA)"
    echo "Duplicates in BED:          $DUPS_BED_COUNT"
    echo "Duplicates in FASTA:        $DUPS_FASTA_COUNT"
    echo "Total Differences (BED/FASTA): $TOTAL_DIFFERENCES"
    echo "Missing IDs (in FASTA, not BED): $MISSING_COUNT"
    echo "Extra IDs (in BED, not FASTA):   $EXTRA_COUNT"
    echo "--------------------------------------------------"
    
    echo "DETAILED BREAKDOWN:"
    
    echo -n "1. Duplicate IDs in BED: "
    if [ "$DUPS_BED_COUNT" -eq 0 ]; then
        echo "None [PASS]"
    else
        echo "$DUPS_BED_COUNT found [FAIL]"
        cat "$BED_DUPS" | sed 's/^/     - /'
    fi
    
    echo -n "2. Duplicate IDs in FASTA: "
    if [ "$DUPS_FASTA_COUNT" -eq 0 ]; then
        echo "None [PASS]"
    else
        echo "$DUPS_FASTA_COUNT found [FAIL]"
        cat "$FASTA_DUPS" | sed 's/^/     - /'
    fi

    echo ""
    echo "3. Missing IDs (Present in FASTA, Missing in BED):"
    if [ "$MISSING_COUNT" -eq 0 ]; then
        echo "   None [PASS]"
    else
        echo "   Total: $MISSING_COUNT"
        cat missing_in_bed.tmp | sed 's/^/     - /'
    fi

    echo ""
    echo "4. Extra IDs (Present in BED, Missing in FASTA):"
    if [ "$EXTRA_COUNT" -eq 0 ]; then
        echo "   None [PASS]"
    else
        echo "   Total: $EXTRA_COUNT"
        cat extra_in_bed.tmp | sed 's/^/     - /'
    fi

    echo "--------------------------------------------------"
    if [ "$DUPS_BED_COUNT" -eq 0 ] && [ "$DUPS_FASTA_COUNT" -eq 0 ] && [ "$MISSING_COUNT" -eq 0 ] && [ "$EXTRA_COUNT" -eq 0 ] && [ "$UNIQUE_BED" -eq "$UNIQUE_FASTA" ]; then
        echo "OVERALL STATUS: [SUCCESS] ALL CHECKS PASSED!"
        echo "Each accession reports no duplicate IDs, no differences,"
        echo "no missing IDs, and no extra IDs."
    else
        echo "OVERALL STATUS: [FAILED] DISCREPANCIES DETECTED."
    fi
    echo "=================================================="
} > "$REPORT"

# Cleanup temporary files
rm -f "$BED_IDS" "$FASTA_IDS" "$BED_DUPS" "$FASTA_DUPS" missing_in_bed.tmp extra_in_bed.tmp

echo "Validation report generated successfully: '$REPORT'"