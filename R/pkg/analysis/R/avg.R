#' Calculate the average matching rate from the selected matching rate file.
#'
#' @param x a matching rate file.
#'
#' @export
#'

avg <- function(x) {

  row.num <- dim(x)[1]
  print(paste("avg:", round(sum(x$V2) / row.num, digits = 2)))
  print(paste("perfect words:", sum(x$V2 == 100)))
  print(paste("perfect ratio:", round((sum(x$V2 == 100) / row.num) * 100, digits = 2)))

  return(0)
}
