

filenames <- c("/home/rmhawwo/Scratch/batch3_admera/batch3_RNA_alignment/250umA.dedup.bam")

file.exists(filenames)

library("Rsamtools")
bamfiles <- BamFileList(filenames, yieldSize=2000000)   # TELL R THEY ARE BAM FILES
seqinfo(bamfiles[1])                                                                    # PRINT SOME SUMMARY INFO

# source("https://bioconductor.org/biocLite.R")
# biocLite("TxDb.Hsapiens.UCSC.hg19.knownGene")

# READ IN AN ANNOTATION FILE
library("GenomicFeatures")
txdb <- makeTxDbFromGFF("/home/rmhawwo/Scratch/exome_support_files/gencode.v19.annotation.gtf", format = "gtf", circ_seqs = character())
txdb

ebg <- exonsBy(txdb, by="gene")
ebg

# READ COUNTING
library("GenomicAlignments")
library("BiocParallel")

# register(SerialParam())  # FOR SINGLE CORE
register(MulticoreParam(6)) # FOR MULTIPLE CORES

# THIS FUNCTION TAKES A LONG TIME
se <- summarizeOverlaps(features=ebg, reads=bamfiles,
mode="Union",
singleEnd=FALSE,
ignore.strand=TRUE,
fragments=TRUE )

# AT THIS POINT IT IS BEST TO SAVE THE 'se' OBJECT, IT CAN BE USED FOR MANY DOWNSTREAM ANALYSES WITH DIFFERENT PROGRAMS IN BIOCONDUCTER
saveRDS(se, file = "/home/rmhawwo/Scratch/batch3_admera/batch3_RNA_alignment/summarizedExperiment_08Nov2018_250umA_dedup.rds")
