library(GENESPACE)

wd <- "/data/users/apiatkowska/genome_annotation_course/output/genespace/GENESPACE"
focal_genome <- "PA_1"

load(file.path(wd, "results", "gsParams.rda")) # Loads gsParam.
dir.create(file.path(wd, "processed_riparian"), showWarnings = FALSE)

# Compare your accession with TAIR10, ordering scaffolds by synteny:
# the original code provided made a crowded graph, I streathed the graph horizontally and made labels smaller to see them.
plot_riparian(
    gsParam,
    genomeIDs = c("TAIR10", focal_genome),
    refGenome = "TAIR10",
    reorderBySynteny = TRUE,
    chrLabFontSize = 3,
    scalePlotWidth = 2.5,
    pdfFile = file.path(wd, "processed_riparian", "PA_1_vs_TAIR10.pdf")
)