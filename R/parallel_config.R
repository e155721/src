library(doMC)

#cores <- detectCores() / 2
#registerDoMC(cores)

change_cores <- function() {
  time <- as.character(Sys.time())
  time <- strsplit(x = time, split = " ")[[1]][2]
  time <- strsplit(x = time, split = ":")[[1]][1]
  time <- as.numeric(time)
  if ((6 <= time) && (time <= 21)) {
    cores <- detectCores() / 2
    registerDoMC(cores)
  } else {
    cores <- detectCores()
    registerDoMC(cores)
  }
}

change_cores()

source("lib/load_data_processing.R")
make_word_list <- function() {
  file_list <- GetPathList()
  word_list <- lapply(file_list, (function(x){
    MakeInputSeq(MakeWordList(x["input"]))
  }))
  return(word_list)
}
