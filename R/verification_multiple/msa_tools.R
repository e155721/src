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

    psa.list <- ChangeListMSA2PSA(msa_list, s)
    rlt.pmi  <- PairwisePMI(psa.list, word_list, s, method, cv_sep)
    s        <- rlt.pmi$s
  }

  msa.o          <- list()
  msa.o$msa_list <- msa_list
  msa.o$pmi.mat  <- rlt.pmi$pmi.mat
  msa.o$s        <- s
  msa.o
}
