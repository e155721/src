get_word_id <- function(x) {
  paste(strsplit(x, "")[[1]][7:9], collapse = "")
}

make_word_list <- function(file) {
  
  ## CSV files are not read correctly on a container if the 'fileEncoding' is specified.
  csv <- read.csv(file, stringsAsFactors = F)
  
  word_id_org_order <- unlist(lapply(csv[, 3], get_word_id))
  word_id <- sort(unique(unlist(lapply(csv[, 3], get_word_id))))
  word_list <- list()
  M <- length(word_id)
  
  assumed_form_all <- csv[, 6]
  
  word_no <- 1
  
  for (i in 1:M) {
    
    idx <- word_id_org_order == word_id[i]
    assumed_form <- unique(csv[idx, 6])

    N <- length(assumed_form)
    for (j in 1:N) {
      csv_tmp <- csv[idx, , drop=F]
      csv_tmp <- csv_tmp[assumed_form[j] == assumed_form_all, , drop=F]
      csv_tmp <- csv_tmp[!is.na(csv_tmp[, 11]), , drop=F]
  
      word_list[[word_no]] <- strsplit(csv_tmp[, 11], split = "_")
      region_list <- as.list(csv_tmp[, 23])
      O <- length(word_list[[word_no]])
      for (k in 1:O) {
        word_list[[word_no]][[k]] <- matrix(c(region_list[[k]], word_list[[word_no]][[k]]), nrow = 1)
      }
      attributes(word_list[[word_no]]) <- list(word = paste(word_id[i], "_", assumed_form[j], sep = ""))
      word_no <- word_no + 1
    }
    
  }
  
  return(word_list)
}
