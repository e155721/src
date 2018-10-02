.myfunc.env <- new.env()
sys.source("execute_alignment/executeNwunsch.R", envir = .myfunc.env)
sys.source("execute_alignment/checkCorrectAlignment.R", envir = .myfunc.env)
attach(.myfunc.env)

checkCorrectAlignment(input_path = "../Alignment/ex_data/",
                      input_correct_path = "../Alignment/check_data/",
                      s1 = 1, 
                      s2 = 1,
                      s3 = -1,
                      s4 = -1, 
                      s5 = -4,
                      gap = -2)

executeNwunsch(output_path = "../Alignment/align_data/",
               s1 = 1, 
               s2 = 1,
               s3 = -1,
               s4 = -1, 
               s5 = -5,
               gap = -2)
