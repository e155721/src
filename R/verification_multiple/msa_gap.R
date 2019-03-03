source("verification_multiple/VerifForEeach.R")

methods <- c("rf", "bf", "rd")
for (method in methods) {
  for (p in -3:-5) {
    verif(method, output = paste(method, p, ".rlt", sep = ""), p = p)
  }
}
