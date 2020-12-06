make_word_list <- function(file_list) {
  word_list <- lapply(file_list, (function(x){
    seq_list <- MakeInputSeq(MakeWordList(x["input"]))
    attributes(seq_list) <- list(word = gsub("\\..*$", "", x["name"]))
    return(seq_list)
  }))
  return(word_list)
}