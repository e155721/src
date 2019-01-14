.myfunc.env <- new.env()
source("data_processing/MakeWordList.R")
source("needleman_wunsch/NeedlemanWunsch.R")
source("needleman_wunsch/MakeScoringMatrix.R")
source("needleman_wunsch/MakeFeatureMatrix.R")


CheckCorrectAlignment <- function(input_path = "../Alignment/input_data/",
                                  input_correct_path = "../Alignment/correct_data/",
                                  output_compare_path = "../Alignment/compare.txt",
                                  output_ansrate_path = "../Alignment/ansrate.txt",
                                  s1 = 1, 
                                  s2 = 1,
                                  s3 = -1,
                                  s4 = -1, 
                                  s5 = -3,
                                  p1 = -1,
                                  p2 = -1)
{
  # make scoring matrix
  #scoring_matrix <- MakeScoringMatrix(s1, s2, s3, s4, s5)
  scoring_matrix <- MakeFeatureMatrix(s5)
  
  # input files list
  name_list <- list.files(input_path)
  read_path_list <- paste(input_path, name_list, sep = "")
  
  # check files list
  correct_name_list <- list.files(input_correct_path)
  read_correct_path_list <- paste(input_correct_path, correct_name_list, sep = "")
  
  # get number of words
  number_of_words <- length(name_list)
  
  sink(output_compare_path, append = T)
  print("Parameter:")
  #print(paste("s1:  ", s1))
  #print(paste("s2:  ", s2))
  #print(paste("s3:  ", s3))
  #print(paste("s4:  ", s4))
  print(paste("s5:  ", s5))
  print(paste("gap_open: ", p1))
  print(paste("gap_ext : ", p2))
  cat("\n")
  sink()
  
  for (i in 1:number_of_words) {
    word_list <- MakeWordList(read_path_list[[i]])
    check_word_list <- MakeWordList(read_correct_path_list[[i]])
    word_list_length <- length(word_list)
    
    assumed_form_check <- paste(check_word_list[[1]], collapse = " ")
    assumed_form <- word_list[[1]]
    rlt_list <- list()
    correct <- 0
    sink(output_compare_path, append = T)
    for (k in 1:word_list_length) {
      # Needleman-Wunsch
      align <- NeedlemanWunsch(assumed_form, word_list[[k]], p1, p2, scoring_matrix)
      
      align_seq1 <- paste(align[["seq1"]], collapse = " ")
      align_seq2 <- paste(align[["seq2"]], collapse = " ")
      correct_align <- paste(check_word_list[[k]], collapse = " ")
      if ((align_seq2 == correct_align) && (k != 1)) {
      #if (align_seq2 == correct_align) {
        correct <- correct + 1
      }
      if ((align_seq2 != correct_align) && (k != 1)) {
      #if (align_seq2 != correct_align) {
        print(name_list[[i]])
        print(k-1)
        print(paste("original  : ", assumed_form_check, sep = ""))
        print(paste("correct   : ", correct_align, sep = ""))
        print(paste("align_seq1: ", align_seq1, sep = ""))
        print(paste("align_seq2: ", align_seq2, sep = ""))
        cat("\n")
        #break
      }
    }
    sink()
    
    sink(output_ansrate_path, append = T)
    result <- paste(name_list[[i]], (correct)/(word_list_length-1)*100, sep = " ")
    #result <- paste(name_list[[i]], (correct)/(word_list_length)*100, sep = " ")
    print(result, quote = F)
    sink()
  }
}
