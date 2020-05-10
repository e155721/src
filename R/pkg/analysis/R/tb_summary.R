#' Plot the sammary table from a list of data.
#'
#' @param x a list of data.n
#'
#' @importFrom xtable xtable
#' @export
#'

tb_summary <- function(x) {

  if (is.list(x)) {
    n <- length(x)
    tb <- NULL
    for (i in 1:n) {
      tb <- rbind(tb, t(as.matrix(summary(x[[i]]))))
    }
    xtable(tb)
  } else {
    print("The input must be list!!")
    return(0)
  }

}
