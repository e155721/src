source("lib/needleman_wunsch/scoring_function/general.R")


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

  # horizontal gap
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

  # trace back and making alignment
  align1 <- matrix(seq1[, 1], nrow = dim(seq1)[1])
  align2 <- matrix(seq2[, 1], nrow = dim(seq2)[1])

  i <- len_seq1
  j <- len_seq2
  while (TRUE) {
    if (i == 1 && j == 1) break
    path <- mat[i, j, 2]
    if (path == 0) {
      align1 <- cbind(align1, seq1[, i])
      align2 <- cbind(align2, seq2[, j])
      i <- i - 1
      j <- j - 1
    } else if (path == 1) {
      align1 <- cbind(align1, seq1[, i])
      align2 <- cbind(align2, g2)
      i <- i - 1
    } else if (path == -1) {
      align1 <- cbind(align1, g1)
      align2 <- cbind(align2, seq2[, j])
      j <- j - 1
    }
  }

  align <- rbind(align1, align2)
  ncol <- dim(align)[2]
  align[, 2:ncol] <- align[, ncol:2]
  align1 <- align[1, , drop = F]
  align2 <- align[2, , drop = F]

  # return
  psa <- list()
  psa$seq1 <- align1
  psa$seq2 <- align2
  psa$aln <- align
  psa$score <- mat[len_seq1, len_seq2, 1]

  return(psa)
}
