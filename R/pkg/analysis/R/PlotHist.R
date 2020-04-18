#' Plot a graph of a histogram of an inputted file.
#'
#' @param file an input file.
#'
#' @importFrom graphics abline axis hist par text
#' @importFrom utils read.table
#' @export
#'

plot_hist <- function(file) {
  # Read the data file
  data <- read.table(file)$V2
  mean <- mean(data)
  data_len <- length(data)

  # Configure the font of the histogram.
  par(font.lab = 2, font.axis = 2, cex.axis = 1.5, cex.lab = 1.5)
  hist(data, breaks = seq(0, 100, 10), main = file,
       right = F,
       labels = T,
       xaxt = "n",
       ylim = c(0, data_len),
       xlab = "Matching Rate (%)",
       ylab = "Word Frequency")
  axis(1, at = seq(0, 100, 10), pos = -3)
  abline(v = mean, col = 2, lwd = 3, lty = 2)  # Plot the broken line.
  text(x = mean(data) - 25, y  =  110,     # Plot the average matching rate.
       paste("Average Matching Rate =", round(mean, digits = 3), "%", sep = " "),
       col = 2, font = 2, cex = 1.5)
}
