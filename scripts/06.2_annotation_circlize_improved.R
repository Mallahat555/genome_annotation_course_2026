# Load packages
library(circlize)
library(tidyverse)
library(ComplexHeatmap)

# 1. Load TE annotation GFF3 file safely
gff_file <- "/data/users/apiatkowska/genome_annotation_course/output/EDTA/assembly.fasta.mod.EDTA.TEanno.gff3"
gff_data <- read.table(
    gff_file,
    header = FALSE,
    sep = "\t",
    stringsAsFactors = FALSE,
    comment.char = "#",
    quote = ""
)

# 2. Load MAKER gene annotation GFF file without trailing ##FASTA lines
gene_gff_file <- "/data/users/apiatkowska/genome_annotation_course/output/MAKER/assembly.all.maker.gff"
raw_lines <- readLines(gene_gff_file)
fasta_idx <- grep("^##FASTA", raw_lines)
if (length(fasta_idx) > 0) {
    raw_lines <- raw_lines[seq_len(fasta_idx[1] - 1)]
}

gene_data <- read.table(
    text = raw_lines,
    header = FALSE,
    sep = "\t",
    stringsAsFactors = FALSE,
    comment.char = "#",
    quote = "",
    fill = TRUE
)

# Per-row check for valid 9-column annotation rows with numeric start/end
gene_data <- gene_data[
    !is.na(gene_data$V9) & gene_data$V9 != "" &
    !is.na(gene_data$V4) & !is.na(gene_data$V5),
]
gene_data$V4 <- as.numeric(gene_data$V4)
gene_data$V5 <- as.numeric(gene_data$V5)

# Check feature counts
gff_data$V3 %>% table()
gene_data$V3 %>% table()

# 3. Custom ideogram data (top 20 longest scaffolds)
custom_ideogram <- read.table(
    "/data/users/apiatkowska/genome_annotation_course/data/assembly.fasta.fai",
    header = FALSE,
    stringsAsFactors = FALSE
)
custom_ideogram <- custom_ideogram %>%
    transmute(chr = V1, start = 1, end = as.numeric(V2)) %>%
    arrange(desc(end)) %>%
    slice_head(n = 20)

sum(custom_ideogram$end)

# 4. Helper to filter features for the selected scaffolds
filter_superfamily <- function(gff_df, superfamily, ideogram_df) {
    gff_df %>%
        filter(V3 == superfamily, V1 %in% ideogram_df$chr) %>%
        transmute(
            chrom = V1,
            start = as.numeric(V4),
            end = as.numeric(V5),
            strand = V7
        )
}

# 5. Plot TE and gene density tracks
pdf("03-TE_density.pdf", width = 10, height = 10)
gaps <- c(rep(1, nrow(custom_ideogram) - 1), 5)
circos.par(start.degree = 90, track.margin = c(0, 0), gap.degree = gaps)
circos.genomicInitialize(custom_ideogram)

circos.genomicDensity(
    filter_superfamily(gff_data, "Gypsy_LTR_retrotransposon", custom_ideogram),
    count_by = "number", col = "darkblue", track.height = 0.07, window.size = 1e5
)
circos.genomicDensity(
    filter_superfamily(gff_data, "Copia_LTR_retrotransposon", custom_ideogram),
    count_by = "number", col = "lightblue", track.height = 0.07, window.size = 1e5
)
circos.genomicDensity(
    filter_superfamily(gff_data, "Mutator_TIR_transposon", custom_ideogram),
    count_by = "number", col = "red", track.height = 0.07, window.size = 1e5
)
circos.genomicDensity(
    filter_superfamily(gene_data, "gene", custom_ideogram),
    count_by = "number", col = "black", track.height = 0.07, window.size = 1e5
)

circos.clear()

lgd <- Legend(
    title = "Superfamily",
    at = c("Gypsy_LTR_retrotransposon", "Copia_LTR_retrotransposon", "Mutator_TIR_transposon", "Genes"),
    legend_gp = gpar(fill = c("darkblue", "lightblue", "red", "black"))
)
draw(lgd, x = unit(0.5, "npc"), y = unit(0.5, "npc"), just = c("center", "center"))

dev.off()