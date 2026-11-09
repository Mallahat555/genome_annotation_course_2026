# Improve scaffold order and display orientation.
flips <- data.frame(genome = focal_genome, chr = "YOUR_SCAFFOLD")
    plot_riparian(
        gsParam,
        genomeIDs = c("TAIR10", focal_genome),
        refGenome = "TAIR10",
        reorderBySynteny = TRUE,
        syntenyWeight = 1,
        invertTheseChrs = flips,
        pdfFile = file.path(wd, "processed_riparian", "my_accession_vs_TAIR10_oriented.pdf")
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