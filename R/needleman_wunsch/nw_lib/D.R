library(R6)

D <- 
  R6Class("D",
          public = list(
            seq1 = NA,
            seq2 = NA,
            p1 = NA,
            p2 = NA,
            s = NA,
            
            initialize = function(seq1, seq2, s)
            {
              self$seq1 <- seq1
              self$seq2 <- seq2
              self$s <- s
            },
            
            getScore = function(x, i, j, g1, g2)
            {
              # calculate D(i,j)
              prof1 <- as.matrix(self$seq1[, i])
              prof2 <- as.matrix(self$seq2[, j])
              sp <- SP(prof1, prof2, self$s)
              d1 <- x[i-1, j-1, 1] + sp
              
              # vertical gap
              prof1 <- as.matrix(self$seq1[, i])
              prof2 <- as.matrix(g2)
              sp <- SP(prof1, prof2, self$s)
              d2 <- x[i-1, j, 1] + sp
              
              # horizontally gap
              prof1 <- as.matrix(g1)
              prof2 <- as.matrix(self$seq2[, j])
              sp <- SP(prof1, prof2, self$s)
              d3 <- x[i, j-1, 1] + sp
              
              d <- c(NA, NA)
              d[1] <- min(d1, d2, d3)
              
              lenSeq1 <- dim(self$seq1)[2]
              lenSeq2 <- dim(self$seq2)[2]
              
              if (lenSeq1 <= lenSeq2) {
                if (d[1] == d3) {
                  d[2] <- -1 # (-1,0)
                } else if (d[1] == d2) {
                  d[2] <- 1 # (0,1)
                } else if (d[1] == d1) {
                  d[2] <- 0 # (0,0)
                }
              }
              else if (lenSeq2 < lenSeq1) {
                if (d[1] == d2) {
                  d[2] <- 1 # (0,1)
                } else if (d[1] == d3) {
                  d[2] <- -1 # (-1,0)
                } else if (d[1] == d1) {
                  d[2] <- 0 # (0,0)
                }
              }
              
              return(d)
            }
          )
  )
