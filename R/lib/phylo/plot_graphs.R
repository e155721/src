library(phangorn)

source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")

source("parallel_config.R")

make_msa_dist <- function(msa, s) {

  M <- dim(msa)[1]
  N <- dim(msa)[2]

  reg_vec <- as.vector(msa[, 1])

  mat <- matrix(NA, M, M, dimnames = list(reg_vec, reg_vec))

  comb_reg <- combn(M, 2)
  comb_reg_num <- dim(comb_reg)[2]

  for (i in 1:M) {
    for (j in 1:M) {
      seq1 <- msa[i, , drop = F]
      seq2 <- msa[j, , drop = F]

      as <- 0
      for (k in 2:N) {
        as <- as + s[seq1[, k], seq2[, k]]
      }

      mat[i, j] <- as
    }
  }

  return(mat)
}


plot_tree <- function(phylo, tree_type, out_file) {
  # Plot the tre
  pdf(out_file, width = 25, height = 25)
  plot.phylo(phylo, type = tree_type, lab4ut = "axial")
  dev.off()
}


Plot <- function(msa_list, output_dir, method, s) {

  # Set the directory path for the average tree.
  output_dir_ave   <- paste(output_dir, "tree_ave", sep = "/")
  output_dir_ave_r <- paste(output_dir, "rooted", sep = "/")
  output_dir_ave_u <- paste(output_dir, "unrooted", sep = "/")

  # Set the directory path for the NJ tree.
  output_dir_nj   <- paste(output_dir, "tree_nj", sep = "/")
  output_dir_nj_r <- paste(output_dir_nj, "rooted", sep = "/")
  output_dir_nj_u <- paste(output_dir_nj, "unrooted", sep = "/")

  # Set the directory path for the Neighbor Network.
  output_dir_nnet <- paste(output_dir, "nnet", sep = "/")

  M <- length(msa_list)

  rlt <- foreach(i = 1:M) %dopar% {

    word <- attributes(msa_list[[i]])$word

    msa        <- msa_list[[i]]$aln
    msa_dist   <- make_msa_dist(msa, s)
    msa_dist_d <- as.dist(msa_dist)

    # Phylogenetic Tree
    # Make the NJ tree.
    msa_nj <- try(nj(msa_dist_d), silent = F)
    if (attributes(msa_nj)$class == "try-error") {
      # Make the average tree.
      msa_hc <- hclust(msa_dist_d, "average")
      # Make the 'phylo' object for the average tree.
      msa_hc_phy <- as.phylo(msa_hc)

      # Make the directory for the average trees of the rooted and the unrooted.
      if (!dir.exists(output_dir_ave)) dir.create(output_dir_ave)
      if (!dir.exists(output_dir_ave_r)) dir.create(output_dir_ave_r)
      if (!dir.exists(output_dir_ave_u)) dir.create(output_dir_ave_u)

      # Plot the average trees of the rooted and the unrooted.
      out_file_r <- paste(output_dir_ave_r, "/", word, "_ave_rooted.pdf", sep = "")
      out_file_u <- paste(output_dir_ave_u, "/", word, "_ave_unrooted.pdf", sep = "")
      plot_tree(msa_hc_phy, tree_type = "p", out_file_r)
      plot_tree(msa_hc_phy, tree_type = "u", out_file_u)
    } else {
      # Make the 'phylo' object for the NJ tree.
      msa_nj_phy <- as.phylo(msa_nj)

      # Make the directory for the NJ trees of the rooted and the unrooted.
      if (!dir.exists(output_dir_nj)) dir.create(output_dir_nj)
      if (!dir.exists(output_dir_nj_r)) dir.create(output_dir_nj_r)
      if (!dir.exists(output_dir_nj_u)) dir.create(output_dir_nj_u)

      # Plot the NJ trees of the rooted and the unrooted.
      out_file_r <- paste(output_dir_nj_r, "/", word, "_nj_rooted.pdf", sep = "")
      out_file_u <- paste(output_dir_nj_u, "/", word, "_nj_unrooted.pdf", sep = "")
      plot_tree(msa_nj_phy, "p", out_file_r)
      plot_tree(msa_nj_phy, "u", out_file_u)
    }

    # Neighbor Net
    # Make the Neighbor Network.
    nnet <- try(neighborNet(msa_dist_d), silent = F)
    if (attributes(nnet)$class == "try-error") {

    } else {
      # Make the directory for the Neighbor Network.
      if (!dir.exists(output_dir_nnet)) dir.create(output_dir_nnet)

      # Plot the Neighbor Network.
      out_file_nnet <- paste(output_dir_nnet, "/", word, "_nnet.pdf", sep = "")
      pdf(paste(out_file_nnet, "_nnet.pdf", sep = ""), width = 25, height = 25)
      plot(nnet, "equal angle")
      dev.off()
    }

  }
}
