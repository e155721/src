dir_path <- "../Alignment/wrong_align-1.txt"
files_name <- list.files(dir_path)
files_path <- paste(dir_path, files_name, sep = "")

# make average list of correct answer rate
data_list <- c()
i <- 1
for (f in files_path) {
  data <- read.table(f)$V2
  data <- sum(data)/length(data)
  data_list[[i]] <- data
  i <- i + 1
}

# make max average list of correct answer rate
max_average <- max(data_list)
max_average_files <- list()
i <- 1
j <- 1
for (f in data_list) {
  if (f == max_average) {
    max_average_files[[j]] <- files_path[[i]]
    j <- j + 1
  }
  i <- i + 1
}

# make list of histogram object
h <- list()
i <- 1
for (f in max_average_files) {
  data <- read.table(f)
  h[[i]] <- hist(data$V2, breaks = seq(0,100,10))
  i <- i + 1
}

##
score_list <- list()
i <- 1
for (f in max_average_files) {
  f <- gsub("wrong", "compare", f)
  f <- gsub("_align", "", f)
  f <- gsub("txt", "score", f)
  score <- read.table(f)$V1
  score_list[[i]] <- score[1] - score[2]
  i <- i + 1
}