library(phangorn)

source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")

source("parallel_config.R")

make_psa_dist <- function(psa, s) {

  M <- length(psa)

  regions <- NULL
  j <- 1
  for (i in 1:M) {
    regions[j] <- psa[[i]]$seq1[, 1]
    j <- j + 1
    regions[j] <- psa[[i]]$seq2[, 1]
    j <- j + 1
  }
  regions <- unique(regions)

  N <- length(regions)
  mat <- matrix(0, N, N, dimnames = list(regions, regions))
  for (i in 1:M) {
    seq1 <- psa[[i]]$seq1
    seq2 <- psa[[i]]$seq2

    r1 <- seq1[, 1]
    r2 <- seq2[, 1]

    len <- length(seq1)

    mat[r1, r2] <- sum(diag(s[seq1[, 2:len], seq2[, 2:len]]))

  }

  mat_t <- t(mat)
  mat[lower.tri(mat)] <- mat_t[lower.tri(mat_t)]

  return(mat)
}


plot_tree <- function(phylo, tree_type, out_file) {
  # Plot the tre
  pdf(out_file, width = 25, height = 25, family = "Japan1")
  plot.phylo(phylo, type = tree_type, lab4ut = "axial")
  dev.off()
}


Plot <- function(psa_list, output_dir, method, s) {

  output_dir  <- paste(output_dir, "graph1", sep = "/")
  if (!dir.exists(output_dir)) dir.create(output_dir)

  output_tree <- paste(output_dir, "tree", sep = "/")
  if (!dir.exists(output_tree)) dir.create(output_tree)

  # Set the directory path for the average tree.
  output_tree_ave   <- paste(output_tree, "ave", sep = "/")
  output_tree_ave_r <- paste(output_tree_ave, "rooted", sep = "/")
  output_tree_ave_u <- paste(output_tree_ave, "unrooted", sep = "/")

  # Set the directory path for the NJ tree.
  output_tree_nj   <- paste(output_tree, "nj", sep = "/")
  output_tree_nj_r <- paste(output_tree_nj, "rooted", sep = "/")
  output_tree_nj_u <- paste(output_tree_nj, "unrooted", sep = "/")

  # Set the directory path for the Neighbor Network.
  output_nnet <- paste(output_dir, "network", sep = "/")

  # Set the directory path for the distance matrix.
  output_dist <- paste(output_dir, "dist_mat", sep = "/")
  if (!dir.exists(output_dist)) dir.create(output_dist)

  M <- length(psa_list)

  rlt <- foreach(i = 1:M) %dopar% {

    word <- attributes(psa_list[[i]])$word
    word <- unlist(strsplit(word, split = "_"))
    word <- paste(word[c(1, 3)], collapse = "_")  # combine the word ID and the assumed form.

    psa        <- psa_list[[i]]
    psa_dist   <- make_psa_dist(psa, s)
    psa_dist_d <- as.dist(psa_dist)

    write.nexus.dist(psa_dist_d, file = paste(output_dist, "/", word, "_dist_mat.nexus", sep = ""))

    # Phylogenetic Tree
    # Make the NJ tree.
    psa_nj <- try(nj(psa_dist_d), silent = F)
    if (attributes(psa_nj)$class == "try-error") {
      # Make the average tree.
      psa_hc <- hclust(psa_dist_d, "average")
      # Make the 'phylo' object for the average tree.
      psa_hc_phy <- as.phylo(psa_hc)

      # Make the directory for the average trees of the rooted and the unrooted.
      if (!dir.exists(output_tree_ave)) dir.create(output_tree_ave)
      if (!dir.exists(output_tree_ave_r)) dir.create(output_tree_ave_r)
      if (!dir.exists(output_tree_ave_u)) dir.create(output_tree_ave_u)

      # Plot the average trees of the rooted and the unrooted.
      out_file_r <- paste(output_tree_ave_r, "/", word, "_ave_rooted.pdf", sep = "")
      out_file_u <- paste(output_tree_ave_u, "/", word, "_ave_unrooted.pdf", sep = "")
      plot_tree(psa_hc_phy, tree_type = "p", out_file_r)
      plot_tree(psa_hc_phy, tree_type = "u", out_file_u)
    } else {
      # Make the 'phylo' object for the NJ tree.
      psa_nj_phy <- as.phylo(psa_nj)

      # Make the directory for the NJ trees of the rooted and the unrooted.
      if (!dir.exists(output_tree_nj)) dir.create(output_tree_nj)
      if (!dir.exists(output_tree_nj_r)) dir.create(output_tree_nj_r)
      if (!dir.exists(output_tree_nj_u)) dir.create(output_tree_nj_u)

      # Plot the NJ trees of the rooted and the unrooted.
      out_file_r <- paste(output_tree_nj_r, "/", word, "_nj_rooted.pdf", sep = "")
      out_file_u <- paste(output_tree_nj_u, "/", word, "_nj_unrooted.pdf", sep = "")
      plot_tree(psa_nj_phy, "p", out_file_r)
      plot_tree(psa_nj_phy, "u", out_file_u)
    }

  }
}
