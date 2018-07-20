size <- length(word_list)
rlt <- list()
#for (i in 2:73) {
for (i in 1:10) {
  #sink("test.aln", append = T)
  print(paste(i, word_list[[i]]), sep = ": ")
  needlemanWunsch(as.vector(word_list[[1]]), as.vector(word_list[[i]]), p)
  #sink()
}
