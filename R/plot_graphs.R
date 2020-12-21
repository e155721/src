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
        print(k)
        as <- as + s[seq1[, k], seq2[, k]]
      }

      mat[i, j] <- as
    }
  }

  return(mat)
}


plot_tree <- function(phylo, tree_method, out_file) {
  # Rooted Tree
  pdf(paste(out_file, "_", tree_method, "_rooted.pdf", sep = ""), width = 25, height = 25)
  plot.phylo(phylo, type = "c")
  dev.off()
  # Unrooted Tree
  pdf(paste(out_file, "_", tree_method, "_unrooted.pdf", sep = ""), width = 25, height = 25)
  plot.phylo(phylo, type = "u", lab4ut = "axial")
  dev.off()
}


Plot <- function(msa_list, output_dir, method, s) {

  M <- length(msa_list)

  rlt <- foreach(i = 1:M) %dopar% {

    f <- file_list[[i]]
    out_file <- paste(output_dir, "/", gsub(".org", "", f["name"]), sep = "")
    msa <- msa_list[[i]]$aln

    msa_dist <- make_msa_dist(msa, s)
    msa_dist_d <- as.dist(msa_dist)

    if (1) {
      msa_nj <- try(nj(msa_dist_d), silent = F)
      if (attributes(msa_nj)$class == "try-error") {
        print(f["name"])
      } else {
        msa_nj_phy <- as.phylo(msa_nj)
        plot_tree(msa_nj_phy, "nj", out_file)
      }

      msa_hc <- hclust(msa_dist_d, "average")
      msa_hc_phy <- as.phylo(msa_hc)
      plot_tree(msa_hc_phy, "average", out_file)
    }

    # Neighbor Net
    if (1) {
      nnet <- try(neighborNet(msa_dist_d), silent = F)
      if (attributes(nnet)$class == "try-error") {
        print(out_file["name"])
      } else {
        pdf(paste(out_file, "_nnet.pdf", sep = ""), width = 25, height = 25)
        plot(nnet, "2D")
        dev.off()
      }
    }
  }
}
