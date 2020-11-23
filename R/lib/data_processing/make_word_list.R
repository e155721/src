make_word_list <- function(file) {

  csv <- read.csv(file, fileEncoding = "UTF-8")

  word_vec <- sort(unique(csv[, 6]))
  word_list <- list()
  M <- length(word_vec)

  for (i in 1:M) {

    idx <- csv[, 6] == word_vec[i]
    word_list[[i]] <- strsplit(csv[idx, 11], split = "_")
    region_list    <- strsplit(csv[idx, 19], split = "_")
    N <- length(word_list[[i]])
    for (j in 1:N) {
      word_list[[i]][[j]] <- matrix(c(region_list[[j]], word_list[[i]][[j]]), nrow = 1)
    }
    attributes(word_list[[i]]) <- list(word = word_vec[i])

  }

  return(word_list)
}
