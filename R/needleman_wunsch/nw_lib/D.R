source("needleman_wunsch/nw_lib/SP.R")

library(R6)

D <-
  R6Class("D",
          private = list(
            seq1 = NA,
            seq2 = NA,
            g1 = NA,
            g2 = NA,
            s = NA
          ),
          
          public = list(
            initialize = function(seq1, seq2, g1, g2, s)
            {
              private$seq1 <- seq1
              private$seq2 <- seq2
              private$g1 <- g1
              private$g2 <- g2
              private$s <- s
            },
            
            D1 = function(x, i, j)
            {
              # calculate D(i,j)
              prof1 <- as.matrix(private$seq1[, i])
              prof2 <- as.matrix(private$seq2[, j])
              sp <- SP(prof1, prof2, private$s)
              d1 <- x[i-1, j-1, 1] + sp
              
              return(d1)
            },
            
            D2 = function(x, i, j)
            {
              # vertical gap
              prof1 <- as.matrix(private$seq1[, i])
              prof2 <- as.matrix(private$g2)
              sp <- SP(prof1, prof2, private$s)
              d2 <- x[i-1, j, 1] + sp
              
              return(d2)
            },
            
            D3 = function(x, i, j)
            {
              # horizontally gap
              prof1 <- as.matrix(private$g1)
              prof2 <- as.matrix(private$seq2[, j])
              sp <- SP(prof1, prof2, private$s)
              d3 <- x[i, j-1, 1] + sp
              
              return(d3)
            },
            
            D4 = function(x, i, j)
            {
              # horizontally gap
              prof1 <- as.matrix(private$g1)
              prof2 <- as.matrix(private$seq2[, j])
              sp <- SP(prof1, prof2, private$s)
              d4 <- x[i-2, j-2, 1] + sp
              
              return(d4)
            }
          )
  )
