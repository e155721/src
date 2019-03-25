source("verification_multiple/for_acc/VerifForEach.R")

if (0) {
  for (i in 1:100) {
    dir <- paste("rd-etr_", i, sep = "")
    dir.create(dir)
    for (p in -3:-5) {
      verif(method = "rd", output = paste(dir, "/", "rd_p", p, ".rlt", sep = ""), p = p)
    }
  }
}

for (p in -3:-5) {
  dir <- paste("../../Alignment/rd-p_", i, sep = "")
  dir.create(dir)
  for (i in 1:100) {
    verif(method = "rd", output = paste(dir, "/", "rd-etr_", i, ".rlt", sep = ""), p = p)
  }
}
