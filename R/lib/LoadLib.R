LoadLib <- function(path) {

  if (!exists("name_list")) {
    assign(x = "name_list", value = list(), envir = .GlobalEnv)
  }

  hit <- sum(path == name_list)
  if (!hit) {

    i <- length(name_list)
    name_list[[(i + 1)]] <<- path

    lib.path <- paste(getwd(), "/", path, "/", sep = "")
    files <- list.files(lib.path, pattern = "*.R$")

    for (f in files) {
      print(f)
      source(paste(lib.path, f, sep = ""))
    }

  }

  return(0)
}
