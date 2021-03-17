source("lib/load_phoneme.R")
source("lib/load_data_processing.R")

source("admixture/functions.R")

mat.C.featB <- as.matrix(read.table("admixture/data/cons_feat_binary.txt", colClasses = "character", fileEncoding = "UTF-8"))
mat.V.featB <- as.matrix(read.table("admixture/data/vowel_feat_binary.txt", colClasses = "character", fileEncoding = "UTF-8"))

row.names(mat.C.featB) <- mat.C.featB[, 1]
mat.C.featB <- mat.C.featB[, -1]

row.names(mat.V.featB) <- mat.V.featB[, 1]
mat.V.featB <- mat.V.featB[, -1]


base_dir <- commandArgs(trailingOnly = TRUE)[1]
#base_dir <- "../../Alignment/202103181617/msa_ld/"
input_dir <- paste(base_dir, "alignment", sep = "/")
out_dir_c <- paste(base_dir, "cons_fas", sep = "/")
out_dir_v <- paste(base_dir, "vowe_fas", sep = "/")
out_dir_c_fas <- paste(out_dir_c, "infile_fol", sep = "/")
out_dir_v_fas <- paste(out_dir_v, "infile_fol", sep = "/")

file_list <- GetPathList(input_dir, pattern = "\\.csv$")
N <- length(file_list)

if (!dir.exists(out_dir_c_fas)) {
  dir.create(out_dir_c_fas, recursive = T)
}

if (!dir.exists(out_dir_v_fas)) {
  dir.create(out_dir_v_fas, recursive = T)
}

fas_list_c <- list()
for (i in 1:N) {
  fas_list_c[[i]] <- gsub(pattern = "\\..*", replacement = "_cons.fas", file_list[[i]]["name"])
}

out_list_c <- list()
for (i in 1:N) {
  out_list_c[[i]] <- paste(out_dir_c_fas, fas_list_c[[i]], sep = "/")
}

fas_list_v <- list()
for (i in 1:N) {
  fas_list_v[[i]] <- gsub(pattern = "\\..*", replacement = "_vowe.fas", file_list[[i]]["name"])
}

out_list_v <- list()
for (i in 1:N) {
  out_list_v[[i]] <- paste(out_dir_v_fas, fas_list_v[[i]], sep = "/")
}

labels <- NULL
for (idx in 1:N) {

  x1 <- read.csv(file_list[[idx]]["input"], stringsAsFactors = F, fileEncoding = "UTF-8", colClasses = "character")
  labels <- unique(c(labels, x1[, 1]))

  x2 <- x1[, -1]
  dx2 <- dim(x2)

  x3_c <- NULL
  x3_v <- NULL
  for (j in 1:dx2[2]) {

    col <- x2[, j]
    X <- check_cv(col)
    switch(X,
           "C" = x3_c <- cbind(x3_c, mat.C.featB[col, ]),
           "V" = x3_v <- cbind(x3_v, mat.V.featB[col, ])
    )

  }

  x3_c <- zero_to_A(x3_c)
  x3_c <- one_to_T(x3_c)

  x3_v <- zero_to_A(x3_v)
  x3_v <- one_to_T(x3_v)

  write_fas(x3_c, out_file = out_list_c[[idx]], labels = labels)
  write_fas(x3_v, out_file = out_list_v[[idx]], labels = labels)

}

labels <- sort(labels)
out_file_sp <- paste(base_dir, "SpList.txt", sep = "/")
write.table(labels, file = out_file_sp, quote = F, row.names = F, col.names = F, fileEncoding = "UTF-8")
file.copy(out_file_sp, out_dir_c)
file.copy(out_file_sp, out_dir_v)
#write.table(labels, file = paste(out_dir_c, "SpList.txt", sep = "/"), quote = F, row.names = F, col.names = F, fileEncoding = "UTF-8")
#write.table(labels, file = paste(out_dir_v, "SpList.txt", sep = "/"), quote = F, row.names = F, col.names = F, fileEncoding = "UTF-8")
