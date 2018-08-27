source("/Users/e155721/OkazakiLab/src/data_processing/translateSymbolArraysIntoVC.R")

input_path <- "/Users/e155721/OkazakiLab/src/tmp"
output_path <- "/Users/e155721/OkazakiLab/src/output"

files_list <- paste(input_path, list.files(input_path), sep = "/")
for (f in files_list)
  translateSymbolArraysIntoVC(f, output_path)