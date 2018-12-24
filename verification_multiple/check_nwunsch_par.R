.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

tmp <- function(x)
{
  nrow <- dim(x)[1]
  ncol <- dim(x)[2]
  
  sp <- 0
  for (j in 2:ncol) {
    spVec <- x[, j]
    l <- 2
    len <- length(spVec)
    for (k in 1:(len-1)) {
      for (m in l:len) {
        sp <- sp + scoringMatrix[spVec[k], spVec[m]]
      }
      l <- l + 1
    }
  }
  return(sp)
}

path <- "../Alignment/input_data/"
files <- list.files(path)
files <- paste(path, files, sep = "")

nwunsch <- function(f)
{
  print(f)
  
  wordList <- MakeWordList(f)
  wl.len <- length(wordList)
  seq1 <- NeedlemanWunsch(wordList[[1]], wordList[[2]], s = scoringMatrix, p, p)
  
  if (wl.len >= 3) {
    for (i in 3:wl.len) {
      seq1 <- NeedlemanWunsch(seq1$multi, wordList[[i]], s = scoringMatrix, p, p)
    }
  }
  if (seq1$score != tmp(seq1$multi)) {
    print(f)
  }
  return(0)
}

lapply(files, nwunsch)
