source("verification_multiple/for_acc/VerifForEach.R")

for (p in -3:-5) {
  dir <- paste("../../Alignment/rd-p_", p, sep = "")
  dir.create(dir)
  for (i in 1:100) {
    verif(method = "rd", output = paste(dir, "/", "rd-etr_", i, ".rlt", sep = ""), p = p)
  }
}
