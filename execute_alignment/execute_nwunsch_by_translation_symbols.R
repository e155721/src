.myfunc.env <- new.env()
sys.source("data_processing/makeWordList.R", envir = .myfunc.env)
sys.source("data_processing/functions_to_convert_symbol.R", envir = .myfunc.env)
sys.source("needleman_wunsch/needlemanWunsch.R", envir = .myfunc.env)
attach(.myfunc.env)

# input files list
name_list <- list.files("../Alignment/ex_data/")
number_of_words <- length(name_list)

# input paths and output paths list
read_path_list <- paste("../Alignment/ex_data/", name_list, sep = "")
write_path_list <- paste("../Alignment/align_data/", name_list, ".aln", sep = "")

for (i in 1:number_of_words) {
  word_list <- makeWordList(read_path_list[[i]])
  word_list_length <- length(word_list)

  assumed_form <- toCorV(word_list[[1]])
  rlt_list <- list()
  sink(write_path_list[[i]], append = T)
  for (i in 1:word_list_length) {
    print(i)
    seq2 <- toCorV(word_list[[i]])
    rlt <- needlemanWunsch(assumed_form[["sym"]], seq2[["sym"]], p = -1, scoring_matrix)
    #print(toOrg(rlt[["seq1"]], assumed_form[["org"]]))
    print(toOrg(rlt[["seq2"]], seq2[["org"]]))
  }
  sink()
}