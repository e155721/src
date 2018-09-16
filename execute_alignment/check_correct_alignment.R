.myfunc.env <- new.env()
sys.source("data_processing/makeWordList.R", envir = .myfunc.env)
#sys.source("data_processing/excel_data_abstraction.R", envir = .myfunc.env)
sys.source("data_processing/functions_to_convert_symbol.R", envir = .myfunc.env)
sys.source("needleman_wunsch/needlemanWunsch.R", envir = .myfunc.env)
attach(.myfunc.env)

# check files list
check_name_list <- list.files("../Alignment/check_data/")
read_check_path_list <- paste("../Alignment/check_data/", check_name_list, sep="")

# input files list
name_list <- list.files("../Alignment/ex_data/")
numbers_of_words <- length(name_list)

# input paths and output paths list
read_path_list <- paste("../Alignment/ex_data/", name_list, sep = "")
write_path_list <- paste("../Alignment/align_data/", name_list, ".aln", sep = "")

for (i in 1:numbers_of_words) {
  word_list <- makeWordList(read_path_list[[i]])
  check_word_list <- makeWordList(read_check_path_list[[i]])
  word_list_length <- length(word_list)
  
  assumed_form <- toCorV(word_list[[1]])
  rlt_list <- list()
  for (k in 1:word_list_length) {
    #print(i)
    seq2 <- toCorV(word_list[[k]])
    rlt <- needlemanWunsch(assumed_form[["sym"]], seq2[["sym"]], p = -1, scoring_matrix)
    r <- toOrg(rlt[["seq2"]], seq2[["org"]])
    
    r <- paste(r, collapse = "")
    c <- paste(check_word_list[[k]], collapse = "")
    print(paste("align: ",r))
    print(paste("org:   ", c))
    if (r != c) {
      print(name_list[[i]])
      break
    }
  }
}