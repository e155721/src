sheet <- read.table("abstraction_array_pattern/data.txt")
pattern <- as.matrix(unique(sheet$V2))
write.table(pattern, "abstraction_array_pattern/array_pattern.txt")

input_path <- "/Users/e155721/OkazakiLab/src/abstraction_array_pattern-2/pattern_data"
output_path <- "/Users/e155721/OkazakiLab/src/abstraction_array_pattern-2/test"

files_list <- paste(input_path, list.files(input_path), sep = "/")
pattern_list <- list()
i <- 1
for (f in files_list) {
  s <- read.table(f)
  pattern_list[[i]] <- as.matrix(s$V1)
  i <- i + 1
}

abstract_pattern_list <- unique(pattern_list)