source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("verification/methods/MakeEDPairwise.R")
source("verification/methods/MakeCorpus.R")
source("verification/methods/PMI.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

# get the all of files path
filesPath <- GetPathList()

denom.vec <- c(10, 100, 1000, 10000, 100000)
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
    
    # make scoring matrix
    s <- MakeEditDistance(Inf)
    
    # making the gold standard alignments
    gold.aln <- MakeGoldStandard(gold.list)
    
    # making the pairwise alignment in all regions
    psa.rlt <- MakeEDPairwise(input.list, s, select.min = T)
    psa.aln <- psa.rlt$psa
    ed <- psa.rlt$ed
    
    # calculating the matching rate
    matching.rate <- VerifAcc(gold.aln, psa.aln)
    
    # store the org scoring matrix
    s.old <- s
    
    ed.new <- 0
    loop <- 0
    sum.ed <- NULL        
    sum.ed.vec <- c()
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
      s[1:81, 82:118] <- Inf
      s[82:118, 1:81] <- Inf
      
      # updating old scoring matrix
      s.old <- s
      
      # making the pairwise alignment in all regions
      psa.rlt <- MakeEDPairwise(input.list, s, select.min = T)
      psa.aln <- psa.rlt$psa
      ed.new <- psa.rlt$ed
      
      # calculating the matching rate
      matching.rate <- VerifAcc(gold.aln, psa.aln)
      
      # exit condition
      if (ed == ed.new) {
        break
      } else {
        ed <- ed.new
        print(paste(f["name"], ed))
      }
      
      # breaking infinit loop
      if (!is.null(sum.ed)) {
        if (ed == sum.ed) {
          break
        } else {
          loop <- loop+1
        }
        if (loop == 3) {
          sum.ed <- NULL
          sum.ed.vec <- c()
          loop <- 0
        }
      }
      sum.ed.vec <- append(sum.ed, ed)
      sum.ed <- min(sum.ed.vec)
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
