make_word_list <- function(file_list) {
  word_list <- lapply(file_list, (function(x){
    MakeInputSeq(MakeWordList(x["input"]))
  }))
  return(word_list)
}