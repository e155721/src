MakePath <- function(file, dir, ext) {

  if (is.na(ext)) {
    ext <- NULL
  } else {
    ext <- paste("_", ext, sep = "")
  }

  path <- list()

  # Set the path of the matching rate.
  path$ansrate.file <- paste("../../Alignment/", file, ext, "_", format(Sys.Date()), ".txt", sep = "")

  # Set the path of the PSA directory.
  path$output.dir <- paste("../../Alignment/", dir, ext, "_", format(Sys.Date()), "/", sep = "")

  return(path)
}
