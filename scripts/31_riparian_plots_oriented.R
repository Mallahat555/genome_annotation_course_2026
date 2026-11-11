library(GENESPACE)

wd <- "/data/users/apiatkowska/genome_annotation_course/output/genespace/GENESPACE"
focal_genome <- "PA_1"

load(file.path(wd, "results", "gsParams.rda")) # Loads gsParam.
dir.create(file.path(wd, "processed_riparian"), showWarnings = FALSE)

# Improve scaffold order and display orientation.
flips <- data.frame(genome = focal_genome, chr = c("contig_110", "contig_107", "contig_126", "contig_164", "contig_166", "contig_167", "contig_48", "contig_105", "contig_106", "contig_127", "contig_186"))
    plot_riparian(
        gsParam,
        genomeIDs = c("TAIR10", focal_genome),
        refGenome = "TAIR10",
        reorderBySynteny = TRUE,
        syntenyWeight = 1,
        invertTheseChrs = flips,
        pdfFile = file.path(wd, "processed_riparian", "PA_1_vs_TAIR10_oriented.pdf")
    )

# Show all five genomes:

plot_riparian(
        gsParam,
        refGenome = "TAIR10",
        reorderBySynteny = TRUE,
        syntenyWeight = 1,
        invertTheseChrs = flips,
        scalePlotWidth = 1.5,pdfFile = file.path(wd, "processed_riparian", "all_genomes_TAIR10.pdf")
    )