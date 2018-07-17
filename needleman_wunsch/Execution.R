size <- length(word_list)
for (i in 2:26) {
  print(i)
  needlemanWunsch(as.vector(word_list[[1]]), as.vector(word_list[[i]]))
}
