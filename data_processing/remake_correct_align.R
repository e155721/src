.myfunc.env <- new.env()
sys.source("data_processing/makeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

dir_path <- "../Alignment/correct_data/"
files_name <- list.files(dir_path)
files_path <- paste(dir_path, files_name, sep = "")

new_files_name <- gsub("\\..+$", "", files_name)
new_files_path <- paste(dir_path, new_files_name, sep = "")

for (f in files_path) {
  word_list <- makeWordList(f)
  new_word_list <- list()
  wl_len <- length(word_list)
  
  seq1 <- word_list[[1]]
  seq1_first <- word_list[[1]]
  
  w_len <- length(seq1)
  mat <- matrix(NA, wl_len, w_len)
  el_list <- list()
  i <- 2
  while(i <= wl_len) {
    seq2 <- word_list[[i]]
    w_len <- length(seq1)
    j <- 1
    while(j <= w_len) {
      if (seq1[j] == "-" && seq2[j] == "-"){
        el_list <- append(el_list, j, after = length(el_list))
        seq2[j] <- NA
      }
      j <- j + 1
    }

    for (e in el_list) {
      seq1_first[e] <- NA
    }
    mat[1, ] <- seq1_first
    mat[i, ] <- seq2
    
    i <- i + 1
  }
  write.table(mat, paste(f, "txt", sep = "."))
}