source("data_processing/MakeWordList.R")
source("data_processing/GetPathList.R")
source("needleman_wunsch/MakeEditDistance.R")
source("verification/verif_lib/verification_func.R")
source("verification/verif_lib/MakeInputSeq.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

# get the all of files path
filesPath <- GetPathList()

E <- 1
denom.vec <- c(10, 100, 100, 1000, 10000, 100000)
for (denom in denom.vec) {
  
  # initialize epsilon
  E <- E/denom
  print(E)
  
  # matchingrate path
  ansrate.file <- paste("../../Alignment/ansrate_pmi_", format(Sys.Date()), "_01_", E, ".txt", sep = "")
  
  # result path
  output.dir <- paste("../../Alignment/pairwise_pmi_", format(Sys.Date()), "_01_", E, "/", sep = "")
  if (!dir.exists(output.dir)) {
    dir.create(output.dir)
  }
  
  # conduct the alignment for each files
  foreach.rlt <- foreach (f = filesPath) %dopar% {
    
    # make the word list
    gold.list <- MakeWordList(f["input"])
    input.list <- MakeInputSeq(gold.list)
    
    # make scoring matrix
    s <- MakeEditDistance(Inf)
    
    # making the gold standard alignments
    gold.aln <- MakeGoldStandard(gold.list)
    
    # making the pairwise alignment in all regions
    psa.aln <- MakePairwise(input.list, s, fmin = T)
    
    # calculating the matching rate
    matching.rate <- VerifAcc(gold.aln, psa.aln)
    
    # store the org scoring matrix
    s.old <- s
    
    matching.rate.new <- 0
    while (1) {
      # calculating PMI
      newcorpus <- MakeCorpus(psa.aln)
      co.mat <- MakeCoMat(newcorpus)
      v.vec <- dimnames(co.mat)[[1]]
      V <- length(v.vec)
      N <- length(newcorpus)
      maxpmi <- 0
      E <- 1
      for (i in 1:V) {
        for (j in 1:V) {
          a <- v.vec[i]
          b <- v.vec[j]
          if (a!=b) {
            p.xy <- (co.mat[a, b]/N)+E
            p.x <- (g(a, newcorpus)/N)
            p.y <- (g(b, newcorpus)/N)
            pmi <- log2(p.xy/(p.x*p.y))
            s[a, b] <- pmi
            maxpmi <- max(maxpmi, pmi)
          }
        }
      }
      maxpmi <- max(maxpmi)[1]
      
      for (a in v.vec) {
        for (b in v.vec) {
          if (a != b) {
            s[a, b] <- 0-s[a, b]+maxpmi
          }
        }
      }
      
      # updating CV penalties
      # s[1:81, 82:118] <- 10+maxpmi
      # s[82:118, 1:81] <- 10+maxpmi
      s[1:81, 82:118] <- Inf
      s[82:118, 1:81] <- Inf
      
      # updating old scoring matrix
      s.old <- s
      
      # making the pairwise alignment in all regions
      psa.aln <- MakePairwise(input.list, s, fmin = T)
      
      # calculating the matching rate
      matching.rate.new <- VerifAcc(gold.aln, psa.aln)
      
      # exit contraint
      if (matching.rate == matching.rate.new) {
        break
      } else {
        matching.rate <- matching.rate.new
      }
    }
    
    #######
    # output gold standard
    OutputAlignment(f["name"], output.dir, ".lg", gold.aln)
    # output pairwise
    OutputAlignment(f["name"], output.dir, ".aln", psa.aln)
    
    # output the matching rate
    sink(ansrate.file, append = T)
    rlt <- paste(f["name"], matching.rate, sep = " ")
    print(rlt, quote = F)
    sink()
  }
}
