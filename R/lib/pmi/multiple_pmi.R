library(tictoc)
library(doMC)

source("lib/load_data_processing.R")


ChangeListMSA2PSA <- function(msa.list, s) {
  # Make the word list of all the words.
  #
  # Args:
  #   files: The files path of all the words.
  #
  # Returns:
  #   psa_list: The word list of all the words.
  psa_list <- list()
  num.msa <- length(msa.list)
  psa_list <- foreach(i = 1:num.msa, .inorder = T) %dopar% {
    num.reg <- dim(msa.list[[i]]$aln)[1]
    comb.reg <- combn(1:num.reg, 2)
    N <- dim(comb.reg)[2]
    psa <- list()
    for (j in 1:N) {
      aln <- rbind(msa.list[[i]]$aln[comb.reg[1, j], ],
                   msa.list[[i]]$aln[comb.reg[2, j], ])
      aln <- DelGap(aln)
      seq1 <- aln[1, , drop = F]
      seq2 <- aln[2, , drop = F]

      psa[[j]] <- list()
      psa[[j]]$seq1 <- seq1
      psa[[j]]$seq2 <- seq2
      psa[[j]]$aln <- aln
    }
    attributes(psa) <- list(word = attributes(msa.list[[i]])$word)
    return(psa)
    msa.list[[i]] <- NA
  }

  return(psa_list)
}


pa_loop <- function(word_list, s) {

  pa_list <- foreach(seq_list = word_list) %dopar% {
    ProgressiveAlignment(seq_list, s, F)
  }

  return(pa_list)
}


bf_loop <- function(msa_list, s) {

  bf_list <- lapply(msa_list, (function(msa, s){
    bf_list <- BestFirst(msa, s, F)
    return(bf_list)
  }), s)

  return(bf_list)
}


msa_loop <- function(word_list, s, pa=T, msa_list=NULL, method, cv_sep=F) {
  N     <- length(s)
  s.old <- s
  dim_s <- dim(s)[1]
  s.old[1:dim_s, 1:dim_s] <- 0

  loop <- 0
  while (1) {
    diff <- N - sum(s == s.old)
    if (diff == 0) {
      break
    } else {
      s.old <- s
    }

    if (loop == 10) {
      print(paste("msa_loop:", "MAX LOOP"))
      break
    } else {
      loop <- loop + 1
    }
    print(paste("msa_loop:", loop))

    if (pa) {
      msa_list <- pa_loop(word_list, s)
    } else {
      msa_list <- bf_loop(msa_list, s)
    }

    tic("ChangeListMSA2PSA")
    psa_list <- ChangeListMSA2PSA(msa_list, s)
    toc()
    if (attributes(method)$method == "pmi") {
      rlt.pmi  <- PairwisePMI(psa_list, word_list, s, method, cv_sep)
    }
    else if (attributes(method)$method == "pf-pmi0") {
      rlt.pmi  <- PairwisePFPMI(psa_list, word_list, s, method, cv_sep)
    }
    else if (attributes(method)$method == "pf-pmi") {
      rlt.pmi  <- PairwisePMI(psa_list, word_list, s, method, cv_sep)
    }
    s <- rlt.pmi$s
    rm(psa_list)
    gc()
    gc()
  }

  msa.o          <- list()
  msa.o$msa_list <- msa_list
  msa.o$pmi_list <- rlt.pmi$pmi_list
  msa.o$s        <- s
  msa.o
}

MultiplePMI <- function(word_list, s, method, cv_sep=F) {

  N <- length(s)
  s.old.main <- s
  dim_s <- dim(s)[1]
  s.old.main[1:dim_s, 1:dim_s] <- 0

  loop <- 0
  while (1) {
    print("Main loop")
    diff <- N - sum(s == s.old.main)
    if (diff == 0) {
      break
    } else {
      s.old.main <- s
    }

    if (loop == 10) {
      print(paste("MultiplePMI:", "MAX LOOP"))
      break
    } else {
      loop <- loop + 1
    }
    print(paste("MultiplePMI:", loop))

    # For progressive
    print("PA loop")
    pa.o <- msa_loop(word_list, s, pa = T, msa_list = NULL, method, cv_sep = cv_sep)

    pa_list <- pa.o$msa_list
    s       <- pa.o$s
    rm(pa.o)
    gc()
    gc()

    # For best first
    print("BF loop")
    msa.o <- msa_loop(word_list, s, pa = F, msa_list = pa_list, method, cv_sep = cv_sep)

    s <- msa.o$s
    rm(pa_list)
    gc()
    gc()
  }

  return(msa.o)
}
