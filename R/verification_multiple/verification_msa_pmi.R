source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("msa/BestFirst.R")

files <- GetPathList()

ansrate <- "ansrate_msa"
multiple <- "multiple"

accuracy.mat <- matrix(NA, length(files), 2)

# matchingrate path
ansrate.file <- paste("../../Alignment/", ansrate, "_pmi_", format(Sys.Date()), "_", ".txt", sep = "")

# result path
output.dir <- paste("../../Alignment/", multiple, "_pmi_", format(Sys.Date()), "_", "/", sep = "")
if (!dir.exists(output.dir)) {
  dir.create(output.dir)
}

s <- MakeEditDistance(Inf)
for (file in files) {
  
  gold.list <- MakeWordList(file["input"])  # gold alignment
  input.list <- MakeInputSeq(gold.list)  # input sequences
  
  # Computes the MSA using the BestFirst method.
  print(paste("Start:", file["name"]))
  msa <- BestFirst(input.list, s, "PMI")
  print(paste("End:", file["name"]))
  
  # Checks the accuracy of MSA.
  gold.mat <- DelGap(list2mat(gold.list))
  gold.mat <- gold.mat[order(gold.mat[, 1]), ]
  msa <- msa[order(msa[, 1]), ]
  
  # Calculates the MSA accuracy.
  N <- dim(msa)[1]
  matched <- 0
  for (i in 1:N) {
    aligned <- paste(msa[i, ], collapse = " ")
    gold <- paste(gold.mat[i, ], collapse = " ")
    if (aligned == gold)
      matched <- matched + 1
  }
  matching.rate <- (matched / N) * 100
  accuracy.mat <- rbind(accuracy.mat, c(file[["name"]], matching.rate))
  
  # Outputs the MSA.  
  write.table(msa, paste(output.dir, gsub("\\..*$", "", file["name"]), ".aln", sep=""), quote=F)
}

# Outputs the accuracy file.
write.table(accuracy.mat[-1, , drop=F], ansrate.file, quote=F)
