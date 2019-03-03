source("verification_multiple/align_for_each.R")

for (p in -3:-5) {
  verif(method = "rf", output = paste("rf_p", p, ".dat", sep = ""), p = p)
}

for (p in -3:-5) {
  verif(method = "bf", output = paste("bf_p", p, ".dat", sep = ""), p = p)
}

for (p in -3:-5) {
  verif(method = "rd", output = paste("rd_p", p, ".dat", sep = ""), p = p)
}
