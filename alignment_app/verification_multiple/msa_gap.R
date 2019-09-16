source("verification_multiple/for_acc/VerifForEach.R")

methods <- c("rf", "bf", "rd")
for (method in methods) {
  for (p in -3:-5) {
    verif(method, output = paste(method, "_p", p, ".rlt", sep = ""), p = p)
  }
}
