setwd("/Users/ajjeon/Documents/bioIT_self_help")

library(Rsubread)

buildindex(basename="chr1_index", reference="data/chr1.fa.gz")

align.stat <- align(index="chr1_index", 
                    readfile1="data/SRR1552445_1.fastq", 
                    output_file="output/alignResults.BAM")

fcounts <- featureCounts(files="output/alignResults.BAM",
                         annot.inbuilt="mm10")