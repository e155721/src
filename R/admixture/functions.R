del_empty_row <- function(x, id) {

  N <- length(id)
  dx <- dim(x)

  for (i in dx[1]:1) {
    if (i > N) {
      x <- x[-i, ]
    }
  }

  return(x)
}


check_cv <- function(x) {

  y <- unique(x)
  y <- y[y != "-9"]
  y <- y[y != "-1"]
  y <- y[y != "-"]

  y <- y[1]

  if (sum(y == C)) {
    z <- "C"
  }
  else if (sum(y == V)) {
    z <- "V"
  } else {
    message("Error: check_cv")
    stop()
  }

  return(z)
}


rep_names <- function(x, id, label) {

  id <- as.matrix(read.table(id, stringsAsFactors = F, fileEncoding = "UTF-8"))
  label <- as.matrix(read.table(label, stringsAsFactors = F, fileEncoding = "UTF-8"))
  rep_tb <- matrix(id, dimnames = list(label, NULL))

  dx <- dim(x)
  for (i in 1:dx[1]) {
    x[i, 1] <- rep_tb[x[i, 1], ]
  }

  return(x)
}


zero_to_A <- function(x) {
  return(gsub(pattern = "0", replacement = "A", x))
}


one_to_T <- function(x) {
  return(gsub(pattern = "1", replacement = "T", x))
}


write_fas <- function(x1, out_file, labels) {

  dx1 <- dim(x1)
  x2 <- matrix(NA, (dx1[1] * 2), 1)
  i2 <- 1
  for (i in 1:dx1[1]) {
    x2[i2, ] <- paste(">", labels[i], sep = "")
    x2[(i2 + 1), ] <- paste(x1[i, ], collapse = "")
    i2 <- i2 + 2
  }

  write.table(x2, file = out_file, quote = F, row.names = F, col.names = F)

  return(0)
}
