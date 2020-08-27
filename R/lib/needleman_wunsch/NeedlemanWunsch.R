calc_score <- function(prof1, prof2, s) {
  # make profiles
  prof <- rbind(prof1, prof2)
  prof_len <- length(prof)
  len1 <- prof_len - 1
  len2 <- prof_len

  score <- 0
  l <- 2
  for (k in 1:len1) {
    for (m in l:len2) {
      score <- score + s[prof[k], prof[m]]
    }
    l <- l + 1
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

  prof1 <- seq1[, i, drop = F]
  prof2 <- g2
  score <- calc_score(prof1, prof2, s)
  d2 <- x[i - 1, j, 1] + score

  return(d2)
}


calc_d3 <- function(x, i, j, s, g1, seq2) {
  # horizontally gap
  prof1 <- g1
  prof2 <- seq2[, j, drop = F]
  score <- calc_score(prof1, prof2, s)
  d3 <- x[i, j - 1, 1] + score

  return(d3)
}


needleman_wunsch <- function(seq1, seq2, s, select_min=F) {
  # get the lengths of sequences
  len_seq1 <- dim(seq1)[2]
  len_seq2 <- dim(seq2)[2]

  # initialize variable
  g1 <- matrix("-", nrow = dim(seq1)[1])
  g2 <- matrix("-", nrow = dim(seq2)[1])

  # making the distance matrix
  mat <- array(dim = c(len_seq1, len_seq2, 2))

  # initializing the distance matrix
  mat[1, 1, ] <- 0

  # vertical gap
  for (i in 2:len_seq1) {
    mat[i, 1, 1] <- calc_d2(mat, i, 1, s, seq1, g2)
    mat[i, 1, 2] <- 1
  }

  # holiontally gap
  for (j in 2:len_seq2) {
    mat[1, j, 1] <- calc_d3(mat, 1, j, s, g1, seq2)
    mat[1, j, 2] <- -1
  }

  # calculation the distance matrix
  for (i in 2:len_seq1) {
    for (j in 2:len_seq2) {

      d1 <- calc_d1(mat, i, j, s, seq1, seq2)
      d2 <- calc_d2(mat, i, j, s, seq1, g2)
      d3 <- calc_d3(mat, i, j, s, g1, seq2)

      d <- c(NA, NA)
      if (select_min) {
        d[1] <- min(d1, d2, d3)
      } else {
        d[1] <- max(d1, d2, d3)
      }

      if (len_seq1 <= len_seq2) {
        if (d[1] == d3) {
          d[2] <- -1 # (-1,0)
        } else if (d[1] == d2) {
          d[2] <- 1 # (0,1)
        } else if (d[1] == d1) {
          d[2] <- 0 # (0,0)
        }
      }
      else if (len_seq2 < len_seq1) {
        if (d[1] == d2) {
          d[2] <- 1 # (0,1)
        } else if (d[1] == d3) {
          d[2] <- -1 # (-1,0)
        } else if (d[1] == d1) {
          d[2] <- 0 # (0,0)
        }
      }
      mat[i, j, 1:2] <- d

    }
  }

  # trace back
  trace <- c()
  i <- len_seq1
  j <- len_seq2

  while (TRUE) {
    if (i == 1 && j == 1) break
    trace <- append(trace, mat[i, j, 2])
    path <- mat[i, j, 2]
    if (path == 0) {
      i <- i - 1
      j <- j - 1
    } else if (path == 1) {
      i <- i - 1
    } else if (path == -1) {
      j <- j - 1
    }
  }
  trace <- rev(trace)

  # make alignment
  align1 <- matrix(seq1[, 1], nrow = dim(seq1)[1])
  align2 <- matrix(seq2[, 1], nrow = dim(seq2)[1])

  i <- j <- 2
  for (t in trace) {
    if (t == 0) {
      align1 <- cbind(align1, seq1[, i])
      align2 <- cbind(align2, seq2[, j])
      i <- i + 1
      j <- j + 1
    } else if (t == 1) {
      align1 <- cbind(align1, seq1[, i])
      align2 <- cbind(align2, g2)
      i <- i + 1
    } else {
      align1 <- cbind(align1, g1)
      align2 <- cbind(align2, seq2[, j])
      j <- j + 1
    }
  }

  align <- list(NA, NA)
  align[[1]] <- align1
  align[[2]] <- align2

  # return
  psa <- list()
  psa$seq1 <- align[[1]]
  psa$seq2 <- align[[2]]
  psa$aln <- rbind(align[[1]], align[[2]])
  psa$score <- mat[len_seq1, len_seq2, 1]

  return(psa)
}
