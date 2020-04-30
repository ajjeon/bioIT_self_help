setwd("/Users/ajjeon/Documents/bioIT_self_help")
library(DESeq2)

### if you start from RAW.tar files, you have to merge the datasets together

## file_list <- list.files(path="data/",pattern="txt$")
## dataset <- read.table(paste0("data/",file_list[1]),header=TRUE)
## for (i in 2:length(file_list)){
##     temp_data <- read.table(paste0("data/",file_list[i]),header=TRUE)
##     dataset <- cbind(dataset, temp_data[,3])
##     colnames(dataset)[(i+2)] <- colnames(temp_data)[3]
## }

### Alternatively, download the genewise counts. These are essentially the same.

dataset <- read.table("data/GSE60450_Lactation-GenewiseCounts.txt", header=TRUE)

colnames(dataset)[3:14] <- sapply(colnames(dataset)[-1][-1],
                                  function(x) strsplit(x, "_")[[1]][1])

counts <- dataset[,-1][,-1]

rownames(counts) <- as.character(dataset$EntrezGeneID)

metadata <- read.csv("data/metadata.csv", row.names=1)


## DEseq starts here

dds <- DESeqDataSetFromMatrix(countData = counts,
                       colData = metadata,
                       design = ~ devstage + celltype)

keep <- rowSums(counts(dds)) >= 10

dds <- dds[keep,]

dds <- DESeq(dds)

res_celltype <- results(dds)

res_dev <- results(dds, contrast = c("devstage","18.5dP", "virgin"))

resSig <- subset(res_dev, res$padj < 0.1 )

head(resSig[ order( -resSig$log2FoldChange ), ])

plotMA(res_dev)
plotMA(res_celltype)

#plot(res_dev$log2FoldChange, res_dev$pvalue)

### Working with normalized counts
rld <- rlog(dds) # normalization
plotPCA(rld, intgroup=c("devstage","celltype"))

library( "genefilter" )

topVarGenes <- head( order( rowVars( assay(rld) ), decreasing=TRUE ), 35 )

library(gplots) #heatmap.2
library(RColorBrewer)
library(heatmap.plus) # heatmap.plus function 
library(biomaRt)

mart <- useMart(biomart = "ensembl",
                dataset = "mmusculus_gene_ensembl")

test=getBM(attributes = c("mgi_symbol", "entrezgene_id"),
#           filters = "entrezgene_id",
          values = as.numeric(rownames(counts)),
           bmHeader = T,
           mart = mart)


topVarMat <- assay(rld)[topVarGenes,]

convertID <- function(eID) {
    tmp <- test[test[,2] == as.numeric(eID),1]
    return(tmp[!is.na(tmp)])
}

rownames(topVarMat) <- sapply(rownames(topVarMat), convertID)

myCols = cbind(rep(c("yellow","yellow","blue", "blue", "green","green"), 2),
              c(rep("grey",6),rep("black",6)))

heatmap.plus(topVarMat,
             ColSideColors=myCols,
             col = colorRampPalette( rev(brewer.pal(9, "RdBu")) )(255))


