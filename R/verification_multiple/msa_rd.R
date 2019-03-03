source("verification_multiple/align_for_each.R")


for (i in 1:10) {
  dir <- paste("rd-", i, sep = "")
  dir.create(dir)
  for (p in -3:-5) {
    verif(method = "rd", output = paste(dir, "/", "rd_p", p, ".dat", sep = ""), p = p)
  }
}