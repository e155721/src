.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
attach(.myfunc.env)

NeedlemanWunsch <- function(seq1, seq2, p1 = -1, p2 = -1, s)
{
  # initialize variable
  seq1 <- append(seq1, NA, after = 0)
  seq2 <- append(seq2, NA, after = 0)
  D <- D$new(seq1, seq2, p1, p2, s)
  
  # calculate matrix for sequence alignment
  mat <- makeMatrix(seq1, seq2)
  mat <- InitializeMat(mat, p1, p2)
  
  rowLen <- length(seq1)
  colLen <- length(seq2)
  
  for (i in 2:rowLen) {
    for (j in 2:colLen) {
      d <- D$getScore(mat,i,j)
      mat[i, j, 1] <- d[[1]]
      mat[i, j, 2] <- d[[2]]
    }
  }
  
  # trace back
  score <- gap <- c() 
  i <- rowLen
  j <- colLen
  n <- 1
  score <- mat[i, j, 1]
  while (TRUE) {
    if (i == 1 && j == 1) break
    gap[n] <- mat[i, j, 2]
    n <- n + 1
    
    trace <- mat[i, j, 2]
    if (trace == 0) {
      i <- i - 1
      j <- j - 1
    } else if (trace == 1) {
      i <- i - 1
    } else if (trace == -1){
      j <- j - 1
    }
  }
  gap <- rev(gap)
  
  # output alignment
  s1 <- seq1[2:length(seq1)]
  s2 <- seq2[2:length(seq2)]
  
  align1 <- align2 <- c()
  i <- j <- 1
  for (t in 1:length(gap)) {
    if(gap[t] == 0) {
      align1 <- append(align1, s1[i])
      align2 <- append(align2, s2[j])
      i <- i + 1
      j <- j + 1
    } else if(gap[t] == 1) {
      align1 <- append(align1, s1[i])
      align2<- append(align2, "-")
      i <- i + 1
    } else {
      align1 <- append(align1, "-")
      align2 <- append(align2, s2[j])
      j <- j + 1
    }
  }
  
  align <- list(NA, NA)
  names(align) <- c("seq1", "seq2")
  align[["seq1"]] <- align1
  align[["seq2"]] <- align2
  
  return(align)
}
