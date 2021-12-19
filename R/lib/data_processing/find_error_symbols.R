source("lib/load_phoneme.R")
source("lib/load_data_processing.R")
source("parallel_config.R")

check_seq <- function(seq, word) {
  
  # make CV vector.
  CV <- c(C, V)
  
  rlt <- list()
  rlt["region"] <- NULL
  rlt["symbol"] <- NULL
  
  # find error symbols in the seq.
  error_vec <- NULL
  symbol_vec <- seq[, 2:dim(seq)[2]]
  
  symbol_vec_len <- length(symbol_vec)
  for (i in 1:symbol_vec_len) {
    if (sum(symbol_vec[i] == CV) == 0) {
      error_vec[i] <- symbol_vec[i]
    }
  }

  if (is.null(error_vec)) {
    rlt <- NULL
  } else {
    rlt$word   <- word
    rlt$region <- seq[, 1]
    rlt$symbol <- error_vec[!is.na(error_vec)]
  }
  
  return(rlt)
}

find_error_symbols <- function(word_list, file) {
  
  error_symbol_list <- list()
  k <- 1
  
  M <- length(word_list)
  for (i in 1:M) {
    N <- length(word_list[[i]])
    for (j in 1:N) {
      error_symbol_list[[k]] <- check_seq(word_list[[i]][[j]], attributes(word_list[[i]])$word)
      k <- k + 1
    }
  }
  
  # find elements of the list which are included in the 'error_symbol_list'.
  non_zero_elements <- unlist(lapply(error_symbol_list, function(x) {return(as.logical(length(x)))}))
  error_symbol_list <- error_symbol_list[non_zero_elements]
  
  if (length(error_symbol_list) != 0) {
    N <- length(error_symbol_list)
    sink(file, append = F)
    for (i in 1:N) {
      print(error_symbol_list[[i]]$word)
      print(error_symbol_list[[i]]$region)
      print(error_symbol_list[[i]]$symbol)
      cat("\n")
    }
    stop("この入力ファイルはスコア行列にない記号を含んでいます．")
  }
}
