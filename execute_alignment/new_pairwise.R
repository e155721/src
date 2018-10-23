.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
sys.source("needleman_wunsch/needlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/makeFeatureMatrix.R", envir = .myfunc.env)
attach(.myfunc.env)

word_list <- makeWordList("../Alignment/input_data/21-046馬(1-2).dat")
word_list <- word_list[-1]
seq1 <- word_list[[7]]
scoring_matrix <- makeFeatureMatrix(-5)

if (file.exists("../Alignment/test.align")) {
  file.remove("../Alignment/test.align")
}

wl_row <- length(word_list)
wl_col <- length(seq1)
results_matrix <- matrix(NA, wl_row, wl_col)
i <- 1
for (seq2 in word_list) {
  #sink("../Alignment/test.align", append = T)
  results_matrix[i, ] <- needlemanWunsch(seq1, seq2, -5, -5, scoring_matrix)[["seq2"]]
  i <- i + 1
  #print(seq2)
  #sink()
}
