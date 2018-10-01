.myfunc.env <- new.env()
sys.source("data_processing/makeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

makeFeatureList <- function(input_file)
{
  x <- makeWordList(input_file)
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

