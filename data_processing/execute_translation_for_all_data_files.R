source("/Users/e155721/OkazakiLab/src/data_processing/translateSymbolArraysIntoVC.R")

input_path <- "/Users/e155721/OkazakiLab/src/array_pattern_abstraction/preprocessed_data"
output_path <- "/Users/e155721/OkazakiLab/src/array_pattern_abstraction/translated_data"

files_list <- paste(input_path, list.files(input_path), sep = "/")
for (f in files_list)
  translateSymbolArraysIntoVC(f, output_path)