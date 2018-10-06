.myfunc.env <- new.env()
sys.source("execute_alignment/executeNwunsch.R", envir = .myfunc.env)
sys.source("execute_alignment/checkCorrectAlignment.R", envir = .myfunc.env)
sys.source("execute_alignment/makeGapComb.R", envir = .myfunc.env)
attach(.myfunc.env)

makeGapComb <- function(min = 1)
{
  num_list <- list()
  tmp <- list()
  
  num1 <- c(-1:-min)
  num2 <- c(-1:-min)
  
  k <- 1
  for (i in 1:min) {
    for (j in 1:min) {
      tmp[[1]] <- num1[i]
      tmp[[2]] <- num2[j]
      num_list[[k]] <- tmp
      k <- k + 1
    }
  }
  return(num_list)
}

num_list <- makeGapComb()

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
                        gap = i[[2]])
  n <- n + 1
}
