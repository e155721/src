source("verification_multiple/VerifForEach.R")

methods <- c("rf", "bf", "rd")
wordNum <- seq(10,110,10)
for (method in methods) {
  for (words in wordNum) {
    verif(method, output = paste(method, "_p", -3, ".rlt", sep = ""), p = -3, words = words)
  }
}
