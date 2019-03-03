seiseki<-matrix(c(89,90,67,46,50, 57,70,80,85,90,80,90,35,40,50, 40,60,50,45,55,78,85,45,55,60, 55,65,80,75,85,90,85,88,92,95),7,5,byrow = TRUE)
sei.d<-dist(seiseki)
sei.hc<-hclust(sei.d)

mat <- sei.hc$merge
len <- dim(mat)[1]

# check the guide tree
guide <- list()
for (i in 1:len) {
  flg <- sum(mat[i, ] < 0)
  if (flg == 2) {
    guide[[i]] <- mat[i, ]
  } 
  else if(flg == 1) {
    clt <- mat[i, 2]
    guide[[i]] <- append(guide[[clt]], mat[i, 1], after = length(guide[[clt]]))
  } else {
    clt1 <- mat[i, 1]
    clt2 <- mat[i, 2]
    guide[[i]] <- append(guide[[clt1]], guide[[clt2]], after = length(guide[[clt1]]))
  }
}
