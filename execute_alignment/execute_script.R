.myfunc.env <- new.env()
sys.source("execute_alignment/executeNwunsch.R", envir = .myfunc.env)
sys.source("execute_alignment/checkCorrectAlignment.R", envir = .myfunc.env)
sys.source("execute_alignment/makeGapComb.R", envir = .myfunc.env)
attach(.myfunc.env)

num_list <- makeGapComb(10)
n <- 1
for (i in num_list) {
  dir_path <- "../Alignment/"
  output_compare_path <- paste(dir_path, "compare-", n, ".txt", sep = "")
  output_ansrate_path <- paste(dir_path, "ansrate-", n, ".txt", sep = "")
  checkCorrectAlignment(input_path = "../Alignment/ex_data/",
                        input_correct_path = "../Alignment/check_data/",
                        output_compare_path,
                        output_ansrate_path,
                        s5 = i[[1]],
                        p1 = i[[2]],
                        p2 = i[[2]]+1)
  n <- n + 1
}
