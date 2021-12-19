get_word_id <- function(x) {
  paste(strsplit(x, "")[[1]][7:9], collapse = "")
}

make_word_list <- function(file) {
  
  ## CSV files are not read correctly on a container if the 'fileEncoding' is specified.
  csv <- read.csv(file, stringsAsFactors = F)
  
  # Make a vector that includes all word IDs.
  word_id_all <- unlist(lapply(csv[, 3], get_word_id))
  # Make a vector that does not include duplicate word IDs.
  word_id <- sort(unique(unlist(lapply(csv[, 3], get_word_id))))

  word_list <- list()
  M <- length(word_id)

  word_no <- 1
  for (i in 1:M) {
    # Make a T/F vector that indicates rows of the target ID in the CSV file.
    idx <- word_id[i] == word_id_all
    # Make a vector that includes all assumed forms.
    assumed_form_all <- csv[idx, 6]
    # Make a vector that does not include duplicate assumed forms.
    assumed_form <- unique(assumed_form_all)

    N <- length(assumed_form)
    for (j in 1:N) {
      # Extract all rows that have a target word ID from the CSV matrix.
      csv_tmp <- csv[idx, , drop=F]
      # Extract all rows that have a target assumed form.
      csv_tmp <- csv_tmp[assumed_form[j] == assumed_form_all, , drop=F]
      
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
