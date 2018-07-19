size <- length(word_list)
rlt <- list()
#for (i in 2:73) {
for (i in 2:26) {
  sink("test.aln", append = T)
  needlemanWunsch(as.vector(word_list[[1]]), as.vector(word_list[[i]]), p)
  sink()
}