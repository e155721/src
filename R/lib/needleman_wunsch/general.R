calc_score <- function(prof1, prof2, s) {
  # make profiles
  prof <- rbind(prof1, prof2)
  prof_len <- dim(prof)[1]
  M <- prof_len - 1
  N <- prof_len

  score <- 0
  k <- 2
  for (i in 1:M) {
    score <- score + sum(s[prof[i], prof[k:N]])
    k <- k + 1
  }

  return(score)
}


calc_d1 <- function(x, i, j, s, seq1, seq2) {

  prof1 <- seq1[, i, drop = F]
  prof2 <- seq2[, j, drop = F]
  score <- calc_score(prof1, prof2, s)
  d1 <- x[i - 1, j - 1, 1] + score

  return(d1)
}


calc_d2 <- function(x, i, j, s, seq1, g2) {
  # vertical gap
  prof1 <- seq1[, i, drop = F]
  prof2 <- g2
  score <- calc_score(prof1, prof2, s)
  d2 <- x[i - 1, j, 1] + score

  return(d2)
}


calc_d3 <- function(x, i, j, s, g1, seq2) {
  # horizontal gap
  prof1 <- g1
  prof2 <- seq2[, j, drop = F]
  score <- calc_score(prof1, prof2, s)
  d3 <- x[i, j - 1, 1] + score

  return(d3)
}
