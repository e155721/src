source("lib/load_data_processing.R")
source("parallel_config.R")

del_na <- function(x) {

  row <- dim(x)[1]
  for (p in row:1) {
    if (is.na(x[p, 1]))
      x <- x[-p, , drop = F]
  }

  col <- dim(x)[2]
  for (q in col:1) {
    if (is.na(x[1, q]))
      x <- x[, -q, drop = F]
  }

  return(x)
}

make_region_dist <- function(word_list, method, s, output_dir) {
  # Make
  word_vec <- NULL
  for (word in word_list) {
    word_vec <- c(word_vec, gsub("\\(.*\\)", "", attributes(word)$word))
  }
  word_vec2 <- unique(word_vec)

  all_reg <- NULL
  i <- 1
  for (seq_list in word_list) {
    for (seq in seq_list) {
      all_reg[i] <- seq[, 1]
      i <- i + 1
    }
  }
  all_reg <- unique(all_reg)

  word_list2 <- list()
  N <- length(word_vec2)
  for (i in 1:N) {
    word_list2[[i]] <- unlist(word_list[word_vec2[i] == word_vec], recursive = F)
    attributes(word_list2[[i]]) <- list(word = word_vec2[i])
  }

  word_list3 <- list()
  for (i in 1:N) {
    reg_vec <- NULL
    for (seq in word_list2[[i]]) {
      reg_vec <- c(reg_vec, seq[1])
    }
    word_list3[[i]] <- word_list2[[i]][!duplicated(reg_vec)]
    attributes(word_list3[[i]]) <- list(word = word_vec2[i], reg = unique(reg_vec))
  }

  M <- length(all_reg)
  L <- list()
  for (i in 1:M) {
    L[[i]] <- list()
    L[[i]][1:length(word_vec2)] <- NA
  }

  for (i in 1:N) {

    word <- attributes(word_list3[[i]])$word
    reg_vec <- attributes(word_list3[[i]])$reg

    for (reg in reg_vec) {
      idx <- which(reg == all_reg)
      j <- which(word == word_vec2)
      L[[idx]][[j]] <- word_list3[[i]][[which(reg == reg_vec)]]
      attributes(L[[idx]]) <- list(reg = reg)
    }

  }

  pair_mat <- combn(1:N, 2)
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
          ldn_mat[p, q] <- needleman_wunsch(DelGap(seq1), DelGap(seq2), s, select_min = T)$score / len
        }

      }
    }

    ldn_mat <- del_na(ldn_mat)

    dim <- dim(ldn_mat)[1]
    D1 <- sum(diag(ldn_mat)) / length(diag(ldn_mat))
    G <- sum(ldn_mat[upper.tri(ldn_mat, diag = F)], ldn_mat[lower.tri(ldn_mat, diag = F)]) / (dim^2 - dim)
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

  output_nnet <- paste(output_dir, "/", "network", sep = "")
  if (!dir.exists(output_nnet)) dir.create(output_nnet)

  save(L, file = paste(output_nnet, "/", "aln_list_", method, ".RData", sep = ""))
  diag(ldnd_mat) <- 0
  ldnd_mat <- del_na(ldnd_mat)
  save(ldnd_mat, file = paste(output_nnet, "/", "reg_dist_", method, ".RData", sep = ""))

  write.nexus.dist(ldnd_mat, file = paste(output_nnet, "/", "reg_dist_", method, ".nexus", sep = ""))

  return(0)
}
