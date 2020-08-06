zero <- function(x) {
  return(0)
}


pa_loop <- function(list.words, s) {

  pa_list <- list()
  for (w in list.words) {
    # Make the word list.
    gold.list <- MakeWordList(w["input"])  # gold alignment
    seq.list <- MakeInputSeq(gold.list)  # input sequences

    # Computes the MSA using the BestFirst method.
    id <- as.numeric(w["id"])
    pa_list[[id]] <- list()
    pa_list[[id]] <- ProgressiveAlignment(seq.list, s, F)
  }

  pa_list
}


bf_loop <- function(list.words, s, msa_list) {

  for (w in list.words) {
    # Computes the MSA using the BestFirst method.
    id <- as.numeric(w["id"])
    msa_list[[id]] <- BestFirst(msa_list[[id]], s, F)
  }

  msa_list
}


msa_loop <- function(list.words, s, pa=T, msa_list=NULL, method, cv_sep=F) {
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
      msa_list <- pa_loop(list.words, s)
    } else {
      msa_list <- bf_loop(list.words, s, msa_list)
    }

    psa.list <- ChangeListMSA2PSA(msa_list, s)
    rlt.pmi  <- PairwisePMI(psa.list, list.words, s, method, cv_sep)
    s        <- rlt.pmi$s
  }

  msa.o          <- list()
  msa.o$msa_list <- msa_list
  msa.o$pmi.mat  <- rlt.pmi$pmi.mat
  msa.o$s        <- s
  msa.o
}
