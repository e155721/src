source("/Users/e155721/OkazakiLab/src/data_processing/translateSymbolArraysIntoVC.R")

input_path <- "/Users/e155721/OkazakiLab/src/abstraction_array_pattern/preprocessed_data//"
output_path <- "/Users/e155721/OkazakiLab/src/abstraction_array_pattern/translated_data/"

files_list <- paste(input_path, list.files(input_path), sep = "/")
for (f in files_list)
  translateSymbolArraysIntoVC(f, output_path)
