GetFilesPath <- function(inputDir = "../Alignment/input_data/",
                         correctDir = "../Alignment/correct_data/")
{
  # the preparing the data files
  inputFilese <- list.files(inputDir)
  inputPaths <- paste(inputDir, inputFilese, sep = "")
  
  correctFiles <- list.files(correctDir)
  correctPaths <- paste(correctDir, correctFiles, sep = "")
  
  # make the path list
  filesPath <- list()
  numOfFiles <- length(inputFilese)
  for (i in 1:numOfFiles) {
    filesPath[[i]] <- c(NA, NA, NA)
    names(filesPath[[i]]) <- c("input", "correct", "name")
    filesPath[[i]]["input"] <- inputPaths[[i]]
    filesPath[[i]]["correct"] <- correctPaths[[i]]
    filesPath[[i]]["name"] <- inputFilese[[i]]
  }
  
  return(filesPath)
}
