# array pattern abstraction of all wordsst
sheet <- read.table("abstraction_array_pattern/all_arrays.txt")
pattern <- as.matrix(unique(sheet$V2))
write.table(pattern, "abstraction_array_pattern/array_pattern_of_all_words.txt")


# array pattern abstraction by assumed forms
input_path <- "/Users/e155721/OkazakiLab/src/abstraction_array_pattern/translated_data"
output_path <- "/Users/e155721/OkazakiLab/src/abstraction_array_pattern/array_pattern_by_asuumed_forms.txt"

files_list <- paste(input_path, list.files(input_path), sep = "/")
pattern_list <- list()
i <- 1
for (f in files_list) {
  s <- read.table(f)
  pattern_list[[i]] <- unique(as.matrix(s$V1))
  i <- i + 1
}
pattern_list <- unique(pattern_list)

len <- length(pattern_list)
for ( i in 1:len) {
  write.table(pattern_list[[i]], output_path, append = T, col.names = T, row.names = F)
}