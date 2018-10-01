.myfunc.env <- new.env()
sys.source("data_processing/makeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

makeFeatureList <- function()
{
  a <- read.table("../Feature_Data/ex_feature/01-003首(1-2)")
  a <- makeWordList("../Feature_Data/ex_feature/01-003首(1-2)")
  
  list_length <- length(a)
  b <- list()
  tmp <- vector()
  
  for (i in 1:list_length) {
    b[[i]] <- vector()
  }
  
  for (i in 1:list_length){
    vector_length <- length(a[[i]])
    
    for (k in 1:vector_length) {
      tmp <- append(tmp, a[[i]][k], length(tmp))
      if (k %% 5 == 0) {
        b[[i]] <- append(b[[i]], sum(tmp), length(b[[i]]))
        tmp <- vector()
      }
    }
  }
}

