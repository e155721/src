.myfunc.env <- new.env()
sys.source("data_processing/MakeFeatureList.R", envir = .myfunc.env)
attach(.myfunc.env)

# This function return a value that it type is vector
GetFeaturesScore <- function(consonant_file = "../Feature_Data/feature/母音入力数値一覧",
                             vowel_file = "../Feature_Data/feature/子音入力数値一覧")
  
{
  consonant_feature <- makeFeatureList(consonant_file)
  vowel_feature <- makeFeatureList(vowel_file)
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
