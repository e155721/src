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

# matchingrate path
ansrate.file <- paste("../../Alignment/ansrate_pmi_", format(Sys.Date()), ".txt", sep = "")

# result path
output.dir <- paste("../../Alignment/pairwise_pmi_", format(Sys.Date()), "/", sep = "")
if (!dir.exists(output.dir)) {
  dir.create(output.dir)
}

# conduct the alignment for each files
foreach.rlt <- foreach (f = filesPath) %dopar% {
  
  print(paste("input:", f["input"], sep = " "))
  cat("\n")
  
  # make the word list
  gold.list <- MakeWordList(f["input"])
  input.list <- MakeInputSeq(gold.list)
  
  # get the number of the regions
  regions <- length(input.list)
  
  # make scoring matrix
  s <- MakeEditDistance(10)
  
  # making the gold standard alignments
  gold.aln <- MakeGoldStandard(gold.list, regions)
  
  # making the pairwise alignment in all regions
  psa.aln <- MakePairwise(input.list, regions, s, fmin = T)
  
  # calculating the matching rate
  matching.rate <- VerifAcc(gold.aln, psa.aln, regions)
  
  #######
  # print the number of current matched
  print(paste("base matched:", matching.rate))
  
  # store the org scoring matrix
  s.old <- s
  
  matching.rate.new <- 0
  loop <- 1
  while (1) {
    # calculating PMI
    newcorpus <- MakeCorpus(psa.aln)
    co.mat <- MakeCoMat(newcorpus)
    v.vec <- dimnames(co.mat)[[1]]
    V <- length(v.vec)
    N <- length(newcorpus)
    maxpmi <- 0
    for (i in 1:V) {
      for (j in 1:V) {
        a <- v.vec[i]
        b <- v.vec[j]
        if (a!=b) {
          p1 <- (co.mat[a, b]+1)*(N+V)
          p2 <- (g(a, newcorpus)+1)*(g(b, newcorpus)+1)
          pmi <- log2(p1/p2)
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
    s[1:81, 82:118] <- 10+maxpmi
    s[82:118, 1:81] <- 10+maxpmi
    
    # updating old scoring matrix
    s.old <- s
    
    # making the pairwise alignment in all regions
    psa.aln <- MakePairwise(input.list, regions, s, fmin = T)
    
    # calculating the matching rate
    matching.rate.new <- VerifAcc(gold.aln, psa.aln, regions)
    
    # exit contraint
    if (matching.rate == matching.rate.new) {
      break
    } else {
      matching.rate <- matching.rate.new
    }
    
    # print the number of loop
    print(paste("loop:", loop))
    loop <- loop+1
    
    # print the number of current matched
    print(paste("new matched", matching.rate.new))
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
