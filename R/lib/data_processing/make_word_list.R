make_word_list <- function(file) {

  csv <- read.csv(file, fileEncoding = "UTF-8", stringsAsFactors = F)

  word_id <- sort(unique(csv[, 2]))
  word_list <- list()
  M <- length(word_id)

  for (i in 1:M) {

    idx <- csv[, 2] == word_id[i]
    assumed_form <- unique(csv[idx, 6])
    concept      <- unique(csv[idx, 25])

    word_list[[i]] <- strsplit(csv[idx, 11], split = "_")
    region_list    <- as.list(csv[idx, 19])
    N <- length(word_list[[i]])
    for (j in 1:N) {
      word_list[[i]][[j]] <- matrix(c(region_list[[j]], word_list[[i]][[j]]), nrow = 1)
    }
    attributes(word_list[[i]]) <- list(word = paste(word_id[i], "_", concept, "_", assumed_form, sep = ""))

  }

  return(word_list)
}
