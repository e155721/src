source("lib/load_data_processing.R")

concat_seq <- function(input_dir, output_file) {

  infile_fol <- paste(input_dir, "infile_fol/", sep = "/")
  sp_file <- paste(input_dir, "SpList.txt", sep = "/")

  file_list <- GetPathList(infile_fol)
  species <- read.table(sp_file)[, 1]

  for (sp in species) {

    seq <- NULL
    fas <- NULL
    fas[1] <- paste(">", sp, sep = "")

    for (f in file_list) {

      x <- read.table(f["input"])
      labels <- grep(">", x[, 1], invert = F)
      seqs <- grep(">", x[, 1], invert = T)

      y1 <- gsub(pattern = ">", replacement = "", x[labels, ])
      y2 <- x[seqs, ]
      len_seq <- length(unlist(strsplit(y2[1], split = "")))

      # checking
      idx <- charmatch(sp, y1)
      if (!is.na(idx)) {
        seq[(length(seq) + 1)] <- y2[idx]
      } else {
        seq[(length(seq) + 1)] <- paste(rep("-", len_seq), collapse = "")
      }
      fas[2] <- paste(seq, collapse = "")

    }

    if (!file.exists(output_file)) {
      write.table(fas, file = output_file, row.names = F, col.names = F, quote = F, fileEncoding = "UTF-8", append = F)
    } else {
      write.table(fas, file = output_file, row.names = F, col.names = F, quote = F, fileEncoding = "UTF-8", append = T)
    }

  }

  return(0)
}

input_dir <- commandArgs(trailingOnly = TRUE)[1]
output_file <- commandArgs(trailingOnly = TRUE)[2]
concat_seq(input_dir, output_file)

if (0) {

  input_dir <- "~/Downloads/cons_fas/"
  output_file <- "~/Downloads/cons_fas/cons.fas"
  concat_seq(input_dir, output_file)

  input_dir <- "~/Downloads/vowe_fas/"
  output_file <- "~/Downloads/vowe_fas/vowe.fas"
  concat_seq(input_dir, output_file)

}
