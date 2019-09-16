MakeCorMat <- function(wordList, gtree)
{
  # make correct matrix
  nrow <- length(wordList$list)
  ncol <- length(wordList$list[[1]])
  
  corMat <- c()
  for (i in 1:nrow) {
    corMat <- rbind(corMat, wordList$list[[i]])
  }
  
  j <- 1
  while (j <= dim(corMat)[2]) {
    m <- match(corMat[, j], "-")
    m <- !is.na(m)
    if (sum(m) == nrow) {
      corMat <- corMat[, -j]
    }
    j <- j + 1
  }
  
  len <- dim(gtree)[1]
  corGuide <- list()
  for (i in 1:len) {
    flg <- sum(gtree[i, ] < 0)
    if (flg == 2) {
      seq1 <- gtree[i, 1] * -1
      seq2 <- gtree[i, 2] * -1
      aln <- rbind(corMat[seq1, ], corMat[seq2, ])
      corGuide[[i]] <- aln
    } 
    else if(flg == 1) {
      clt <- gtree[i, 2]
      seq2 <- gtree[i, 1] * -1
      aln <- rbind(corGuide[[clt]], corMat[seq2, ])
      corGuide[[i]] <- aln
    } else {
      clt1 <- gtree[i, 1]
      clt2 <- gtree[i, 2]
      aln <- rbind(corGuide[[clt1]], corGuide[[clt2]])
      corGuide[[i]] <- aln
    }
  }
  
  corAlign <- tail(corGuide, n = 1)[[1]]
  return(corAlign)
}
