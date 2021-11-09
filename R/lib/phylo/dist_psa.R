source("lib/load_data_processing.R")
source("lib/load_nwunsch.R")
source("parallel_config.R")

del_na <- function(x) {
  
  N <- dim(x)[1]
  
  # Get indices for each column which all elements are 'NA'.
  na_idx1 <- NULL
  k <- 1
  for (i in 1:N) {
    num_na <- sum(is.na(x[i, ]))
    if (num_na == N) {
      na_idx1[k] <- i
      k <- k + 1
    }
  }
  
  # Get indices for each row which all elements are 'NA'.
  na_idx2 <- NULL
  k <- 1
  for (j in 1:N) {
    num_na <- sum(is.na(x[, j]))
    if (num_na == N) {
      na_idx2[k] <- j
      k <- k + 1
    }
  }
  
  na_idx <- c(na_idx1, na_idx2)
  
  if (!is.null(na_idx)) x <- x[-na_idx, -na_idx]
  
  return(x)
}

phylo_all_word <- function(word_list, method, s, output_dir) {

  # Make the meaning vector.
  word_vec <- NULL
  for (word in word_list) {
    word_vec <- c(word_vec, strsplit(attributes(word)$word, split = "_")[[1]][1])
  }
  word_vec2 <- unique(word_vec)
  
  # Make the region list.
  all_reg <- NULL
  i <- 1
  for (seq_list in word_list) {
    for (seq in seq_list) {
      all_reg[i] <- seq[, 1]
      i <- i + 1
    }
  }
  all_reg <- unique(all_reg)

  # Remake the 'word_list' in which each element has all regions.
  N <- length(word_vec2)
  for (i in 1:N) {
    reg_vec <- NULL
    for (seq in word_list[[i]]) {
      reg_vec <- c(reg_vec, seq[1])
    }
    attributes(word_list[[i]]) <- list(word = word_vec2[i], reg = unique(reg_vec))
  }

  M <- length(all_reg)
  L <- list()
  for (i in 1:M) {
    L[[i]] <- list()
    L[[i]][1:length(word_vec2)] <- NA
  }

  for (i in 1:N) {

    word <- attributes(word_list[[i]])$word
    reg_vec <- attributes(word_list[[i]])$reg

    for (reg in reg_vec) {
      idx <- which(reg == all_reg)
      j <- which(word == word_vec2)
      L[[idx]][[j]] <- word_list[[i]][[which(reg == reg_vec)]]
      attributes(L[[idx]]) <- list(reg = reg)
    }

  }

  pair_mat <- combn(1:M, 2)
  comb_num <- dim(pair_mat)[2]

  ldnd_list <- foreach(idx = 1:comb_num, .inorder = T) %dopar% {

    i <- pair_mat[1, idx]
    j <- pair_mat[2, idx]

    L1 <- L[[i]]
    L2 <- L[[j]]

    ldn_mat  <- matrix(NA, N, N, dimnames = list(word_vec2, word_vec2))
    for (p in 1:N) {
      for (q in 1:N) {
        seq1 <- L1[[p]]
        seq2 <- L2[[q]]

        if (is.na(seq1) || is.na(seq2)) {

        } else {
          len <- max(length(DelGap(seq1)), length(DelGap(seq2))) - 1
          ldn_mat[p, q] <- needleman_wunsch(DelGap(seq1), DelGap(seq2), s)$score / len
        }

      }
    }

    diag_vec <- diag(ldn_mat)
    diag_vec <- diag_vec[!is.na(diag_vec)]
    non_diag <- c(ldn_mat[upper.tri(ldn_mat, diag = F)], ldn_mat[lower.tri(ldn_mat, diag = F)])
    non_diag <- non_diag[!is.na(non_diag)]

    D1 <- sum(diag_vec) / length(diag_vec)
    G  <- sum(non_diag) / length(non_diag)
    D2 <- D1 / G

    attributes(D2) <- list(i = i, j = j)
    return(D2)
  }

  ldnd_mat <- matrix(NA, M, M, dimnames = list(all_reg, all_reg))
  len <- length(ldnd_list)
  for (k in 1:len) {
    i <- attributes(ldnd_list[[k]])$i
    j <- attributes(ldnd_list[[k]])$j

    ldnd_mat[i, j] <- ldnd_list[[k]]
    ldnd_mat[j, i] <- ldnd_list[[k]]

  }

  output_dir <- paste(output_dir, "/", "graph2", sep = "")
  if (!dir.exists(output_dir)) dir.create(output_dir)

  #save(L, file = paste(output_dir, "/", "aln_list_", method, ".RData", sep = ""))
  ldnd_mat <- del_na(ldnd_mat)
  diag(ldnd_mat) <- 0
  #save(ldnd_mat, file = paste(output_dir, "/", "dist_mat_", method, ".RData", sep = ""))

  write.nexus.dist(ldnd_mat, file = paste(output_dir, "/", "dist_mat_", method, ".nexus", sep = ""))

  # To output the PDF files.
  ldnd_mat_t <- t(ldnd_mat)
  ldnd_mat[lower.tri(ldnd_mat)] <- ldnd_mat_t[lower.tri(ldnd_mat_t)]

  ldnd_mat_d  <- as.dist(ldnd_mat)

  # Tree
  ldnd_nj     <- nj(ldnd_mat_d)
  ldnd_nj_phy <- as.phylo(ldnd_nj)
  plot_tree(ldnd_nj_phy, "p", paste(output_dir, "/", "nj_rooted.pdf", sep = ""))
  plot_tree(ldnd_nj_phy, "u", paste(output_dir, "/", "nj_unrooted.pdf", sep = ""))

  return(0)
}
