sheet <- read.table("abstraction_array_pattern/data.txt")
pattern <- as.matrix(unique(sheet$V2))

write.table(pattern, "abstraction_array_pattern/array_pattern.txt")
