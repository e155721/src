source("parallel_config.R")

source("dist/tools/get_regions.R")

source("lib/load_scoring_matrix.R")
source("lib/load_nwunsch.R")

source("lib/load_pmi.R")

load("all_list.RData")

LD <- function(c1, c2, s) {

  N1 <- length(c1)
  N2 <- length(c2)

  score.vec   <- NULL
  psa_list <- list()
  k <- 1
  for (i in 1:N1) {
    for (j in 1:N2) {
      psa           <- needleman_wunsch(c1[[i]], c2[[j]], s, select_min = T)
      psa_list[[k]] <- psa
      score.vec     <- c(score.vec, psa$score)

      k <- k + 1
    }
  }
  psa_list[[which(score.vec == min(score.vec))[1]]]
}

PSAforEachConcept <- function(r1, r2, s) {

  n1 <- NULL
  n2 <- NULL

  N <- length(r1)
  for (i in 1:N) {
    n1[i] <- length(r1[[i]])
    n2[i] <- length(r2[[i]])
  }

  n <- n1 * n2
  zero <- rev(which(n == 0))

  for (i in zero) {
    r1 <- r1[-i]
    r2 <- r2[-i]
  }
  N <- length(r1)

  concepts <- names(r1)
  psa_list <- list()
  k <- 1
  for (i in 1:N) {
    for (j in 1:N) {

      psa_list[[k]] <- LD(r1[[i]], r2[[j]], s)
      k <- k + 1

    }
  }

  psa_list
}

PSAforEachResion <- function(all.list, s) {

  # Make the PSA list.
  r <- t(combn(95, 2))
  N <- dim(r)[1]

  psa_list <- foreach (i = 1:N) %dopar% {

    k <- r[i, 1]
    l <- r[i, 2]

    # region
    r1 <- all.list[[k]]
    r2 <- all.list[[l]]

    PSAforEachConcept(r1, r2, s)
  }

  psa_list
}

# Update the scoring matrix using the PMI.
s <- MakeEditDistance(Inf)  # the initial scoring matrix
psa_list <- PSAforEachResion(all.list, s)  # the initial alignments

s.old <- s
N <- length(s.old)
for (i in 1:N) {
  s.old[i] <- 0
}
# START OF LOOP
while(1) {
  diff <- N - sum(s == s.old)
  if (diff == 0) break
  # Compute the new scoring matrix that is updated by the PMI-weighting.
  s.old <- s
  rlt.pmi <- UpdatePMI(psa_list, s)
  pmi_mat <- rlt.pmi$pmi_mat
  s <- rlt.pmi$s
  # Compute the new PSA using the new scoring matrix.
  psa_list <- PSAforEachResion(all.list, s)
}

save(pmi_mat, file = "pmi_mat.RData")
save(s, file = "pmi_score.RData")
