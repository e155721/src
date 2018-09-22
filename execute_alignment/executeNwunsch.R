.myfunc.env <- new.env()
sys.source("data_processing/makeWordList.R", envir = .myfunc.env)
sys.source("needleman_wunsch/needlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/makeScoringMatrix.R", envir = .myfunc.env)
attach(.myfunc.env)

executeNwunsch <- function(input_path = "../Alignment/ex_data/", 
                           output_path = "../Alignment/align_data/")
{
  # make scoring matrix
  scoring_matrix <- makeScoringMatrix()
  
  # input files list
  name_list <- list.files(input_path)
  number_of_words <- length(name_list)
  
  # input paths and output paths list
  read_path_list <- paste(input_path, name_list, sep = "")
  
  write_base_path <- output_path
  if (!dir.exists(write_base_path)) {
    dir.create(write_base_path)
  }
  write_path_list <- paste(write_base_path, name_list, ".aln", sep = "")
  
  for (i in 1:number_of_words) {
    word_list <- makeWordList(read_path_list[[i]])
    word_list_length <- length(word_list)
    
    assumed_form <- word_list[[1]]
    sink(write_path_list[[i]], append = T)
    for (i in 1:word_list_length) {
      seq2 <- word_list[[i]]
      align <- needlemanWunsch(assumed_form, seq2, p = -1, scoring_matrix)
      print(align[["seq2"]])
    }
    sink()
  }
}
executeNwunsch(output_path = "../Alignment/align_data/")
