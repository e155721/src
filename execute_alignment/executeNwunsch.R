.myfunc.env <- new.env()
source("data_processing/MakeWordList.R")
source("needleman_wunsch/NeedlemanWunsch.R")
source("needleman_wunsch/MakeScoringMatrix.R")
source("needleman_wunsch/MakeFeatureMatrix.R")


executeNwunsch <- function(input_path = "../Alignment/input_data/", 
                           output_path = "../Alignment/align_data/",
                           # s1 = 1, 
                           # s2 = 1,
                           # s3 = -1,
                           # s4 = -1, 
                           s5 = -3,
                           p = -1)
{
  # make scoring matrix
  #scoring_matrix <- MakeScoringMatrix(s1, s2, s3, s4, s5)
  scoring_matrix <- MakeFeatureMatrix(s5)
  
  # input files list
  name_list <- list.files(input_path)
  number_of_words <- length(name_list)
  
  # input paths and output paths list
  read_path_list <- paste(input_path, name_list, sep = "")
  
  write_base_path <- output_path
  if (!dir.exists(write_base_path)) {
    dir.create(write_base_path)
  }
  # remove extensions
  name_list <- gsub("\\..+$", "", name_list)
  write_path_list <- paste(write_base_path, name_list, ".aln", sep = "")
  
  for (f in 1:number_of_words) {
    word_list <- MakeWordList(read_path_list[[f]])
    word_list_length <- length(word_list)
    
    assumed_form <- word_list[[1]]
    sink(write_path_list[[f]], append = T)
    for (i in 1:word_list_length) {
      seq2 <- word_list[[i]]
      align <- NeedlemanWunsch(assumed_form, seq2, p1 = p, p2 = p, scoring_matrix)
      if (i != 1) {
        print(align[["seq1"]])
        print(align[["seq2"]])
        cat("\n")
      }
    }
    sink()
  }
}
