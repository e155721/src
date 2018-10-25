.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("data_processing/makeFeatureList.R", envir = .myfunc.env)
attach(.myfunc.env)

word_list <- MakeWordList("../Alignment/input_data/21-046馬(1-2).dat")
word_list <- word_list[-1]
seq1 <- word_list[[7]]
scoring_matrix <- MakeFeatureMatrix(-5)

wl_row <- length(word_list)
wl_col <- length(seq1)
results_matrix <- matrix(NA, wl_row, wl_col)
i <- 1
for (seq2 in word_list) {
  results_matrix[i, ] <- NeedlemanWunsch(seq1, seq2, -5, -5, scoring_matrix)[["seq2"]]
  i <- i + 1
}

write.table(results_matrix, "../Alignment/test.aln")
