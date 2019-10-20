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

out <- NULL
kMaxLoop <- 10

for (out in -3) {
  
  # epsilon size
  E <- 1/1000
  
  # matchingrate path
  ansrate.file <- paste("../../Alignment/ansrate_pf-pmi_", format(Sys.Date()), out, ".txt", sep = "")
  
  # result path
  output.dir <- paste("../../Alignment/pairwise_pf-pmi_", format(Sys.Date()), out, "/", sep = "")
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
    
    # Makes the scoring matrix.
    s <- MakeFeatureMatrix(-Inf, out)
    
    as <- 0
    loop <- 1
    psa.tmp <- list()
    as.tmp <- NULL
    while (1) {
      # updating CV penalties
      s[1:81, 82:118] <- -Inf
      s[82:118, 1:81] <- -Inf
      psa.aln <- MakePairwise(input.list, s, select.min = F)
      
      # updating old scoring matrix and alignment
      as.new <- 0
      N <- length(psa.aln)
      for (i in 1:N)
        as.new <- as.new + psa.aln[[i]]$score
      
      psa.tmp[[loop]] <- psa.aln
      as.tmp <- c(as.tmp, as.new)
      
      # calculating the matching rate
      matching.rate <- VerifAcc(psa.aln, gold.aln)
      
      # exit condition
      if (as == as.new) {
        break
      } else {
        as <- as.new
        print(paste(f["name"], as))
      }
      
      if (loop > kMaxLoop) {
        print(length(psa.tmp))
        psa.tmp <- tail(psa.tmp, 2)
        as.tmp <- tail(as.tmp, 2)
        
        as.max <- which(as.tmp == max(as.tmp))
        psa.aln <- psa.tmp[[as.max]]
        
        loop <- 1
        #print(paste(f["name"], as))
        break 
      } else {
        loop <- loop + 1
      }
      
      # calculating PMI
      newcorpus <- MakeCorpus(psa.aln)
      co.mat <- MakeCoMat(newcorpus)
      v.vec <- dimnames(co.mat)[[1]]
      V <- length(v.vec)
      N <- length(newcorpus)
      N <- N - (sum(newcorpus == "-") * 2)
      E <- 1
      for (i in 1:V) {
        for (j in 1:V) {
          a <- v.vec[i]
          b <- v.vec[j]
          if (a != b) {
            if ((a!="-") && (b!="-")) {
              p.xy <- (co.mat[a, b]/N)+E
              p.x <- (g(a, newcorpus)/N)
              p.y <- (g(b, newcorpus)/N)
              pmi <- log2(p.xy/(p.x*p.y))
              s[a, b] <- pmi
            }
          }
        }
      }
    }
    
    #######
    # output gold standard
    OutputAlignment(f["name"], output.dir, ".lg", gold.aln)
    # output pairwise
    OutputAlignment(f["name"], output.dir, ".aln", psa.aln)
    # output match or mismatch
    OutputAlignmentCheck(f["name"], output.dir, ".check", psa.aln, gold.aln)
    
    # Returns the matching rate to the list of foreach.
    c(f["name"], matching.rate)
  }
  
  # Outputs the matching rate
  matching.rate.mat <- list2mat(foreach.rlt)
  matching.rate.mat <- matching.rate.mat[order(matching.rate.mat[, 1]), , drop=F]
  write.table(matching.rate.mat, ansrate.file, quote = F)
}
