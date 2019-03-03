source("data_processing/MakeWordList.R")

# MakeFeatureList
MakeFeatureList <- function(input_file)
{
  x <- MakeWordList(input_file)
  list_length <- length(x)
  y <- list()
  tmp <- vector()
  
  for (i in 1:list_length) {
    y[[i]] <- vector()
  }
  
  for (i in 1:list_length){
    vector_length <- length(x[[i]])
    
    for (k in 1:vector_length) {
      tmp <- append(tmp, x[[i]][k], length(tmp))
      if (k %% 5 == 0) {
        y[[i]] <- append(y[[i]], sum(tmp), length(y[[i]]))
        tmp <- vector()
      }
    }
  }
  
  return(y)
}

# This function return a value that it type is vector
GetFeaturesScore <- function(consonant_file = "../Feature_Data/feature/母音入力数値一覧",
                             vowel_file = "../Feature_Data/feature/子音入力数値一覧")
  
{
  consonant_feature <- MakeFeatureList(consonant_file)
  vowel_feature <- MakeFeatureList(vowel_file)
  score_feature <- append(consonant_feature, vowel_feature)
  
  consonant <- paste(read.table("../src/symbols/consonant.txt")$V1, collapse = " ")
  vowel <- paste(read.table("../src/symbols/vowel.txt")$V1, collapse = " ")
  symbols <- paste(consonant, vowel, collapse = "")
  symbols <- as.vector(strsplit(symbols, " ")[[1]])
  
  score_symbols <- vector(length = 118)
  names(score_symbols) <- symbols
  
  for (i in 1:118) {
    score_symbols[i] <- score_feature[[i]]
  }
  
  return(score_symbols)
}
