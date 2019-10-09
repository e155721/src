source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("verification/methods/MakePairwise.R")
source("verification/methods/MakeCorpus.R")
source("verification/methods/PMI.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

# get the all of files path
filesPath <- GetPathList()

PF <- F

#denom.vec <- c(10, 100, 1000, 10000, 100000)
denom.vec <- 1000
for (denom in denom.vec) {
  
  # epsilon size
  E <- 1/denom
  
  # matchingrate path
  ansrate.file <- paste("../../Alignment/ansrate_pmi_", format(Sys.Date()), "_E-", E*denom*denom, ".txt", sep = "")
  
  # result path
  output.dir <- paste("../../Alignment/pairwise_pmi_", format(Sys.Date()), "_E-", E*denom*denom, "/", sep = "")
  if (!dir.exists(output.dir)) {
    dir.create(output.dir)
  }
  
  # conduct the alignment for each files
  foreach.rlt <- foreach (f = filesPath) %dopar% {
    
    # make the word list
    gold.list <- MakeWordList(f["input"])
    input.list <- MakeInputSeq(gold.list)
    
    # making the gold standard alignments
    gold.aln <- MakeGoldStandard(gold.list)
    
    # making the pairwise alignment in all regions
    
    if (PF) {
      # Makes the initial alignment using phoneme features.
      s <- MakeFeatureMatrix(-Inf, -3)
      psa.rlt <- MakePairwise(input.list, s, select.min = F)
    } else {
      s <- MakeEditDistance(Inf)  # make scoring matrix
      psa.rlt <- MakePairwise(input.list, s, select.min = T)
    }
    psa.aln <- psa.rlt$psa
    as <- psa.rlt$as
    
    # calculating the matching rate
    matching.rate <- VerifAcc(gold.aln, psa.aln)
    
    # store the org scoring matrix
    s.old <- s
    
    as.new <- 0
    loop <- 0
    sum.as <- NULL        
    sum.as.vec <- c()
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
            if (PF) {
              # no operations
            } else {
              s[a, b] <- 0-s[a, b]+maxpmi
            }
          }
        }
      }
      
      # updating CV penalties
      
      if (PF) {
        s[1:81, 82:118] <- -Inf
        s[82:118, 1:81] <- -Inf
        psa.rlt <- MakePairwise(input.list, s, select.min = F)
      } else {
        s[1:81, 82:118] <- Inf
        s[82:118, 1:81] <- Inf
        psa.rlt <- MakePairwise(input.list, s, select.min = T)
      }
      
      # updating old scoring matrix and alignment
      s.old <- s
      psa.aln <- psa.rlt$psa
      as.new <- psa.rlt$as
      
      # calculating the matching rate
      matching.rate <- VerifAcc(gold.aln, psa.aln)
      
      # exit condition
      if (as == as.new) {
        break
      } else {
        as <- as.new
        print(paste(f["name"], as))
      }
      
      # breaking infinit loop
      if (!is.null(sum.as)) {
        if (as == sum.as) {
          break
        } else {
          loop <- loop+1
        }
        if (loop == 3) {
          sum.as <- NULL
          sum.as.vec <- c()
          loop <- 0
        }
      }
      sum.as.vec <- append(sum.as, as)
      sum.as <- min(sum.as.vec)
      #print(paste("match:", matching.rate))
      #print(paste("rate :", rate))
      #cat("\n")
      
    }
    
    #######
    # output gold standard
    OutputAlignment(f["name"], output.dir, ".lg", gold.aln)
    # output pairwise
    OutputAlignment(f["name"], output.dir, ".aln", psa.aln)
    # output match or mismatch
    OutputAlignmentCheck(f["name"], output.dir, ".check", psa.aln, gold.aln)
    
    # output the matching rate
    sink(ansrate.file, append = T)
    rlt <- paste(f["name"], matching.rate, sep = " ")
    print(rlt, quote = F)
    sink()
  }
}
