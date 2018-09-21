.myfunc.env <- new.env()
sys.source("data_processing/makeWordList.R", envir = .myfunc.env)
sys.source("data_processing/functions_to_convert_symbol.R", envir = .myfunc.env)
sys.source("needleman_wunsch/needlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/makeScoringMatrix.R", envir = .myfunc.env)
attach(.myfunc.env)

checkCorrectAlignment <- function(input_path = "../Alignment/ex_data/",
                                  input_correct_path = "../Alignment/check_data/",
                                  output_compare_path = "../Alignment/compare.txt",
                                  output_ansrate_path = "../Alignment/ansrate.txt")
{
  # make scoring matrix
  scoring_matrix <- makeScoringMatrix()
  
  # input files list
  name_list <- list.files(input_path)
  read_path_list <- paste(input_path, name_list, sep = "")
  
  
  # check files list
  correct_name_list <- list.files(input_correct_path)
  read_correct_path_list <- paste(input_correct_path, correct_name_list, sep="")
  
  # get number of words
  number_of_words <- length(name_list)
  
  for (i in 1:number_of_words) {
    word_list <- makeWordList(read_path_list[[i]])
    check_word_list <- makeWordList(read_correct_path_list[[i]])
    word_list_length <- length(word_list)
    
    assumed_form <- word_list[[1]]
    rlt_list <- list()
    sink(output_compare_path, append = T)
    for (k in 1:word_list_length) {
      seq2 <- word_list[[k]]
      align <- needlemanWunsch(assumed_form, seq2, p = -1, scoring_matrix)
      
      align <- paste(align[["seq2"]], collapse = "")
      correct_align <- paste(check_word_list[[k]], collapse = "")
      #if ((align != correct_align) && (k != 1)) {
      if (align != correct_align) {
        print(name_list[[i]])
        print(k)
        print(paste("align: ", align))
        print(paste("check: ", correct_align))
        cat("\n")
        break
      }
    }
    sink()
    
    sink(output_ansrate_path, append = T)
    #print(paste(k, "/", word_list_length))
    print(k/word_list_length*100)
    sink()
  }
}

checkCorrectAlignment()