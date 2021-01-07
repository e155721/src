source("lib/load_data_processing.R")

output_msa <- function(msa_list, output_dir, ext, excel=F) {
  # Compute the MSA for each word.
  #
  # Args:
  #   msa_list: The list of MSAs.
  #   output_dir: The path of the MSA directory.
  #
  # Returns:
  #   Nothing.

  if (!dir.exists(output_dir)) {
    dir.create(output_dir)
  }

  M <- length(msa_list)

  for (i in 1:M) {

    word <- attributes(msa_list[[i]])$word
    word <- unlist(strsplit(word, split = "_"))
    word <- paste(word[c(1, 3)], collapse = "_")  # combine the word ID and the assumed form.

    #The MSA will be sorted by the regions.
    msa <- msa_list[[i]]$aln
    msa <- msa[order(msa[, 1]), ]

    # Unified the gap insertion.
    msa <- Convert(msa)

    # Outputs the MSA.
    if (excel) {
      write_excel_csv(as.data.frame(msa), file = paste(output_dir, gsub("\\..*$", "", word), ext, sep = ""),
                      eol = "\n", na = "NA", )
    } else {
      write.csv(msa, file = paste(output_dir, gsub("\\..*$", "", word), ext, sep = ""),
                quote = T, eol = "\n", na = "NA", row.names = F,
                fileEncoding = "UTF-8")
    }
  }

  return(0)
}
