source("dist/tools/make_mat.R")

load("all_list.RData")

# Definitions
r1 <- all.list[[1]]
r2 <- all.list[[2]]
c1 <- r1[[1]]
c2 <- r2[[2]]

method <- "lv"
s      <- MakeEditDistance()

# The test for psa() function.
psa_for_each_form(c1, c2, method, s)

# The test for MakeMat() function.
MakeMat(r1, r2, method)
