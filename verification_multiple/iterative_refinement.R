.myfunc.env = new.env()
sys.source("verification_multiple/ProgressiveAlignment.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

file <- "../Alignment/input_data/002.dat"
file <- "../Alignment/input_data/025.dat"

wordList <- MakeWordList(file)

p <- -3
smat <- MakeFeatureMatrix(s5 = -10, p)
paRlt <- ProgressiveAlignment(wordList, -3, smat)

pa <- paRlt$multi

before <- paRlt$score
n <- dim(pa)[1]
max <- 2 * n * n
i <- 1
count <- 0
while (i <= n) {
  org <- pa
  seq1 <- pa[i, ]
  seq1 <- gsub("-", NA, seq1)
  seq1 <- seq1[!is.na(seq1)]
  seq1 <- t(as.matrix(seq1))
  seq2 <- pa[-i, ]
  rlt <- NeedlemanWunsch(seq1, seq2, -3, -3, smat)
  after <- rlt$score
  pa <- rlt$multi
  
  if (after <= before) {
    i <- i + 1
    pa <- org
  } else {
    count <- count + 1
    before <- after
    print(count)
  }
  
  if (count == max) {
    break
  }
}
