

# R SCRIPT


filenames <- c(
"/home/rmhawwo/Scratch/lcm_RNASeq_batch1/LCM_BAMS/ng100.SNT.bam",
"/home/rmhawwo/Scratch/lcm_RNASeq_batch1/LCM_BAMS/ng10.SNT.bam",
"/home/rmhawwo/Scratch/lcm_RNASeq_batch1/LCM_BAMS/ng1.SNT.bam",
"/home/rmhawwo/Scratch/lcm_RNASeq_batch1/LCM_BAMS/pg100A.SNT.bam",
"/home/rmhawwo/Scratch/lcm_RNASeq_batch1/LCM_BAMS/pg100B.SNT.bam",
"/home/rmhawwo/Scratch/lcm_RNASeq_batch1/LCM_BAMS/pg10A.SNT.bam",
"/home/rmhawwo/Scratch/lcm_RNASeq_batch1/LCM_BAMS/pg10B.SNT.bam",
"/home/rmhawwo/Scratch/lcm_RNASeq_batch1/LCM_BAMS/pg500A.SNT.bam",
"/home/rmhawwo/Scratch/lcm_RNASeq_batch1/LCM_BAMS/pg500B.SNT.bam"
	)
file.exists(filenames)

library("Rsamtools")
bamfiles <- BamFileList(filenames, yieldSize=2000000)   # TELL R THEY ARE BAM FILES
seqinfo(bamfiles[1])									# PRINT SOME SUMMARY INFO

# source("https://bioconductor.org/biocLite.R")
# biocLite("TxDb.Hsapiens.UCSC.hg19.knownGene")

# READ IN AN ANNOTATION FILE
library("GenomicFeatures")
txdb <- makeTxDbFromGFF("/home/rmhawwo/Scratch/exome_support_files/gencode.v19.annotation.gtf", format = "gtf", circ_seqs = character())
# txdb <- makeTxDbFromGFF("/home/rmhawwo/Scratch/BAM_files/hg37/gencode.v26lift37.annotation.gtf", format = "gtf", circ_seqs = character())
txdb

ebg <- exonsBy(txdb, by="gene")
ebg

# READ COUNTING
library("GenomicAlignments")
library("BiocParallel")

# register(SerialParam())  # FOR SINGLE CORE
register(MulticoreParam(12)) # FOR MULTIPLE CORES


# THIS FUNCTION TAKES A LONG TIME
se <- summarizeOverlaps(features=ebg, reads=bamfiles,
                        mode="Union",
                        singleEnd=FALSE,
                        ignore.strand=TRUE,
                        fragments=TRUE )
						
# AT THIS POINT IT IS BEST TO SAVE THE 'se' OBJECT, IT CAN BE USED FOR MANY DOWNSTREAM ANALYSES WITH DIFFERENT PROGRAMS IN BIOCONDUCTER

saveRDS(se, file = "summarizedExperiment_x_20Jul2018_SNT.rds")
saveRDS(se, file = "/home/rmhawwo/Scratch/lcm_RNASeq_batch1/LCM_BAMS/summarizedExperiment_x_20Jul2018_SNT.rds")
