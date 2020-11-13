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
  for (i in 1:num.msa) {
    num.reg <- dim(msa.list[[i]]$aln)[1]
    comb.reg <- combn(1:num.reg, 2)
    N <- dim(comb.reg)[2]
    psa_list[[i]] <- list()

    for (j in 1:N) {
      aln <- rbind(msa.list[[i]]$aln[comb.reg[1, j], ],
                   msa.list[[i]]$aln[comb.reg[2, j], ])
      aln <- DelGap(aln)
      seq1 <- aln[1, , drop = F]
      seq2 <- aln[2, , drop = F]

      psa_list[[i]][[j]] <- list()
      psa_list[[i]][[j]]$seq1 <- seq1
      psa_list[[i]][[j]]$seq2 <- seq2
      psa_list[[i]][[j]]$aln <- aln
    }
  }

  return(psa_list)
}


zero <- function(x) {
  return(0)
}


pa_loop <- function(word_list, s) {

  pa_list <- lapply(word_list, (function(seq_list, s){
    pa_list <- ProgressiveAlignment(seq_list, s, F)
    return(pa_list)
  }), s)

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
  s.old <- apply(s.old, MARGIN = c(1, 2), zero)

  while (1) {
    diff <- N - sum(s == s.old)
    if (diff == 0) {
      break
    } else {
      s.old <- s
    }

    if (pa) {
      msa_list <- pa_loop(word_list, s)
    } else {
      msa_list <- bf_loop(msa_list, s)
    }

    psa_list <- ChangeListMSA2PSA(msa_list, s)
    rlt.pmi  <- PairwisePMI(psa_list, word_list, s, method, cv_sep)
    s        <- rlt.pmi$s
  }

  msa.o          <- list()
  msa.o$msa_list <- msa_list
  msa.o$pmi_list  <- rlt.pmi$pmi_list
  msa.o$s        <- s
  msa.o
}

MultiplePMI <- function(word_list, s, method, cv_sep=F) {

  N <- length(s)
  s.old.main <- s
  s.old.main <- apply(s.old.main, MARGIN = c(1, 2), zero)

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
      print("MAX LOOP!!")
      break
    } else {
      loop <- loop + 1
    }

    # For progressive
    print("PA loop")
    pa.o <- msa_loop(word_list, s, pa = T, msa_list = NULL, method, cv_sep = cv_sep)

    pa_list <- pa.o$msa_list
    s       <- pa.o$s

    # For best first
    print("BF loop")
    msa.o <- msa_loop(word_list, s, pa = F, msa_list = pa_list, method, cv_sep = cv_sep)

    msa_list <- msa.o$msa_list
    s        <- msa.o$s

  }

  return(msa.o)
}
