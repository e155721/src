#' Plot the boxplot which is list of the data.
#'
#' @param x a vector or a list of data.
#' @param names a vector of x-axis name.
#'
#' @importFrom graphics boxplot
#' @export
#'

plot_boxp <- function(x, names=NULL) {
  par(font.lab = 2, font.axis = 2)
  boxplot(x, xant = "n", xlab = "Method", ylab = "Accuracy", names = names)
}
