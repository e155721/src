#' Calculate the sample variance of a vector.
#'
#' @param x a vector
#'
#' @export
#'

svar <- function(x) {
  m <- mean(x)
  sum((x - m)^2) / length(x)
}
