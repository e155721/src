source("data_processing/DelGap.R")
source("needleman_wunsch/NeedlemanWunsch.R")
source("verification/PMI.R")

ForEachRegion <- function(f, correct, wordList, s,
                          ansratePath, comparePath, regions)
{
  # making gold standard
  MakeGoldStandard(f, correct, comparePath, regions, s)

  # making pairwise
  rlt <- MakePairwise(f, correct, wordList, s,
                      ansratePath, comparePath, regions)
  count <- rlt$count
  corpus <- rlt$corpus

  # print the number of current matched
  print(paste("base matched:", count))

  # store the org scoring matrix
  s.old <- s

  newcount <- 0
  loop <- 1
  while (1) {

    newcorpus <- MakeCorpus(corpus)
    col <- dim(newcorpus)[2]
    max <- 100
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

    s.row <- dim(s)[1]
    s.col <- dim(s)[2]
    for (t1 in 1:s.row) {
      for (t2 in 1:s.col) {
        if (s.old[t1,t2] != s[t1,t2]) {
          s[t1,t2] <- 0-s[t1,t2]+maxpmi
        }
      }
    }
    s.old <- s

    # making pairwise
    rlt <- MakePairwise(f, correct, wordList, s,
                        ansratePath, comparePath, regions)
    newcount <- rlt$count
    corpus <- rlt$corpus

    # exit contraint
    if (loop == max) {
      break
    }
    if (count == newcount) {
      break
    } else {
      count <- newcount
    }

    # print the number of loop
    print(paste("loop:", loop))
    loop <- loop+1

    # print the number of current matched
    print(paste("new matched", newcount))
  }

  cpsrow <- length(corpus)
  i <- 1
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

  return(s)
}
