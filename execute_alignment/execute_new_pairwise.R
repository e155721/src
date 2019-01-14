
source("needleman_wunsch/NeedlemanWunsch.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("data_processing/MakeWordList.R")


s5 <- -2
p1 <- -5
p2 <- -5

# make input file path
inputDir <- "../Alignment/input_data/"
filesName <- list.files(inputDir)
inputFiles <- paste(inputDir, filesName, sep = "")

# make output file path
outputDir <- "../Alignment/align_data/"
newFilesName <- gsub("\\..+$", ".aln", filesName)
outputFiles <- paste(outputDir, newFilesName, sep = "")

# index of outputFiles
outputInd <- 1

# make scoring matrix
scoring_matrix <- MakeFeatureMatrix(s5)

if (file.exists(outputDir) == F) {
  dir.create(outputDir)
}

for (f in inputFiles) {
  
  # remove original form
  wordList <- MakeWordList(f)
  wordList <- wordList[-1]
  
  # search max length word
  wLength <- c()
  for (w in wordList) {
    wLength <- append(wLength, length(w), length(wLength))
  }
  names(wordList) <- wLength
  seq1 <- wordList[[as.character(max(wLength))]]
  
  # execute pairwise alignment
  i <- 1
  alignLength <- c()
  alignList <- list()
  for (seq2 in wordList) {
    alignList[[i]] <- NeedlemanWunsch(seq1, seq2, p1, p2, scoring_matrix)[["seq2"]]
    alignLength <- append(alignLength, length(alignList[[i]]))
    i <- i + 1
  }
  
  # search a max length alignment
  names(alignList) <- alignLength
  wlRow <- length(alignList)
  wlCol <- max(alignLength)
  resultsMatrix <- matrix(NA, wlRow, wlCol)
  
  # make resultsMatrix after filled a blank of alignment result
  i <- 1
  for (aln in alignList) {
    alnCol <- length(aln)
    diff <- wlCol - alnCol
    if (diff != 0) {
      for (k in 1:diff) {
        aln <- append(aln, NA, length(aln))
      }
      #  k <- 1
      #  while (k <= diff) {
      #    aln <- append(aln, NA, length(aln))
      #    k <- k + 1
      #  }
      #}
    }
    resultsMatrix[i, ] <- aln
    i <- i + 1
  }
  
  # write the result_matrix to the file
  write.table(resultsMatrix, outputFiles[[outputInd]])
  outputInd <- outputInd + 1
}
