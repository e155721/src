.myfunc.env <- new.env()
source("execute_alignment/CheckCorrectAlignment.R")


# constant penalty
num_list <- makeGapComb(10, 1)
n <- 1
for (i in num_list) {
  dir_path <- "../Alignment/"
  if (!dir.exists(dir_path))
    dir.create(dir_path)
  output_compare_path <- paste(dir_path, "compare-", n, ".txt", sep = "")
  output_ansrate_path <- paste(dir_path, "ansrate-", n, ".txt", sep = "")
  CheckCorrectAlignment(input_path = "../Alignment/input_data/",
                        input_correct_path = "../Alignment/correct_data/",
                        output_compare_path,
                        output_ansrate_path,
                        s5 = i[[1]],
                        p1 = i[[2]],
                        p2 = i[[2]])
                        #s5 = -2,
                        #p1 = -5,
                        #p2 = -5)
  n <- n + 1
}


if (0) {
  # affine gap penalty
  num_list <- makeGapComb(10)
  for (ext in 1:3) {
    n <- 1
    for (i in num_list) {
      dir_path <- "../Alignment/"
      dir_path <- output_compare_dir <- paste(dir_path, "ext_open_", ext, "/", sep = "")
      if (!dir.exists(dir_path))
        dir.create(dir_path)
      output_compare_path <- paste(dir_path, "compare-", n, ".txt", sep = "")
      output_ansrate_path <- paste(dir_path, "ansrate-", n, ".txt", sep = "")
      CheckCorrectAlignment(input_path = "../Alignment/input_data/",
                            input_correct_path = "../Alignment/correct_data/",
                            output_compare_path,
                            output_ansrate_path,
                            s5 = i[[1]],
                            p1 = i[[2]],
                            p2 = i[[2]] + ext)
      n <- n + 1
    }
  }
}
