source("data_processing/DelGap.R")
source("needleman_wunsch/NeedlemanWunsch.R")
source("verification/PMI.R")

MakeGoldStandard <- function(f, correct, comparePath, regions, s)
{
  # making gold standard
  l <- 2
  for (k in 1:(regions-1)) {
    # the start of the alignment for each the region pair
    for (i in l:regions) {
      correctMat <- DelGap(rbind(correct[[k]], correct[[i]]))
      rltCor <- paste(paste(correctMat[1, ], correctMat[2, ], sep = ""), collapse = "")
      
      # gold standard
      sink(paste(comparePath, gsub("\\..*$", "", f["name"]), ".lg", sep = ""), append = T)
      cat("\n")
      print(paste(correctMat[1, ], collapse = " "))
      print(paste(correctMat[2, ], collapse = " "))
      sink()
    }
    # the end of the aligne for each the region pair
    l <- l + 1
  }
}

MakePairwise <- function(f, correct, wordList, s,
                         ansratePath, comparePath, regions)
{
  rlt <- list()
  rlt["corpus"] <- list()
  rlt["count"] <- 0
  cpsind <- 1
  
  l <- 2
  count <- 0
  for (k in 1:(regions-1)) {
    # the start of the alignment for each the region pair
    for (i in l:regions) {
      correctMat <- DelGap(rbind(correct[[k]], correct[[i]]))
      align <- NeedlemanWunsch(as.matrix(wordList[[k]], drop = F),
                               as.matrix(wordList[[i]], drop = F), s)
      rltAln <- paste(paste(align$seq1, align$seq2, sep = ""), collapse = "")
      rltCor <- paste(paste(correctMat[1, ], correctMat[2, ], sep = ""), collapse = "")
      
      # counting correct alignment
      if (rltAln == rltCor) {
        count <- count + 1
      }
      
      if (0) {
        # by The Needleman-Wunsch
        sink(paste(comparePath, gsub("\\..*$", "", f["name"]), ".aln", sep = ""), append = T)
        cat("\n")
        print(paste(align$seq1, collapse = " "))
        print(paste(align$seq2, collapse = " "))
        sink()
      }
      
      rlt$corpus[[cpsind]] <- align$seq1
      rlt$corpus[[cpsind+1]] <- align$seq2
      cpsind <- cpsind+2
      
    }
    # the end of the aligne for each the region pair
    l <- l + 1
  }
  
  rlt$count <- count
  
  return(rlt)
}

MakeCorpus <- function(corpus)
{
  cpsrow <- length(corpus)
  i <- 3
  seq1.all <- t(as.matrix(corpus[[1]][-1], drop = F))
  seq2.all <- t(as.matrix(corpus[[2]][-1], drop = F))
  while (i <= cpsrow) {
    seq1.all <- cbind(seq1.all, t(as.matrix(corpus[[i]][-1], drop = F)))
    seq2.all <- cbind(seq2.all, t(as.matrix(corpus[[i+1]][-1], drop = F)))
    i <- i+2  
  }
  newcorpus <- rbind(seq1.all, seq2.all)
  return(newcorpus)
}

ForEachRegion <- function(f, correct, wordList, s,
                          ansratePath, comparePath, regions)
{
  # making gold standard
  MakeGoldStandard(f, correct, comparePath, regions, s)
  
  newcount <- 0
  z <- 1
  while (1) {
    # making pairwise
    rlt <- MakePairwise(f, correct, wordList, s,
                        ansratePath, comparePath, regions)
    count <- rlt$count
    corpus <- rlt$corpus
    
    if (count == newcount)
      break
    
    print(z)
    z <- z+1
    
    newcorpus <- MakeCorpus(corpus)
    col <- length(newcorpus)
    maxpmi <- 0
    for (j in 1:col) {
      a <- newcorpus[1, j]
      b <- newcorpus[2, j]
      pmi <- PMI(a,b,newcorpus)
      s[a,b] <- pmi
      if (maxpmi<pmi) {
        maxpmi <- pmi
      }
    }
    
    if (0) {
      s.row <- dim(s)[1]
      s.col <- dim(s)[2]
      for (t1 in 1:s.row) {
        for (t2 in 1:s.col) {
          s[t1,t2] <- 0-s[t1,t2]+maxpmi
        }
      }
    }
  }
  
  cpsrow <- length(corpus)
  while (i <= cpsrow) {
    # by The Needleman-Wunsch
    sink(paste(comparePath, gsub("\\..*$", "", f["name"]), ".aln", sep = ""), append = T)
    cat("\n")
    print(paste(corpus[[i]], collapse = " "))
    print(paste(corpus[[i+1]], collapse = " "))
    sink()
    i <- i+2
  }
  
  # output the matching rate
  sink(ansratePath, append = T)
  npairs <- sum((regions-1):1)
  matchingRate <- rlt$count / npairs * 100
  rlt <- paste(f["name"], matchingRate, sep = " ")
  print(rlt, quote = F)
  sink()
  
  return(0)
}
