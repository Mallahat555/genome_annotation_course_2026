library(GENESPACE)

wd <- "/data/users/apiatkowska/genome_annotation_course/output/genespace/GENESPACE"
focal_genome <- "PA_1"

load(file.path(wd, "results", "gsParams.rda")) # Loads gsParam.
dir.create(file.path(wd, "processed_riparian"), showWarnings = FALSE)

# Compare your accession with TAIR10, ordering scaffolds by synteny:
plot_riparian(
    gsParam,
    genomeIDs = c("TAIR10", focal_genome),
    refGenome = "TAIR10",
    reorderBySynteny = TRUE,
    pdfFile = file.path(wd, "processed_riparian", "my_accession_vs_TAIR10.pdf")
)