# Sunday, October 20th, 2019
# Script for experiments the Seminar-21

# Calculates the number of average matching rate
a <- NULL
b <- NULL
for (i in 1:100) {
  
  a.table <- read.table(paste("../../Alignment/ex_10-21/ansrate_pf-pmi_constraint_2019-10-21-", i, ".txt", sep = ""))
  b.table <- read.table(paste("../../Alignment/ex_10-21/ansrate_pf-pmi_unconstraint_2019-10-21-", i, ".txt", sep = ""))
  
  a <- c(a, mean(a.table$V2))
  b <- c(b, mean(b.table$V2))
  
}

x <- "Gap Penalty"
y <- "Average Matching Rate (%)"

plot(x=(-100:-1), y=rev(a), type = "l", col="red", lwd=3, xlim=c(-100, -1), ylim=c(90, 93), xlab=x, ylab=y)
par(new=T)
plot(x=(-100:-1), y=rev(b), type = "l", col="blue", lwd=3, xlim=c(-100, -1), ylim=c(90, 93), xlab=x, ylab=y)

# Finds the number of words that are higher or lower matching rates.
a.table <- read.table("../../Alignment/ex_10-21/ansrate_pf-pmi_constraint_2019-10-21-12.txt")
b.table <- read.table("../../Alignment/new_psa/ansrate_2019-10-23/ansrate_p_03.txt")

a.table <- read.table("../../Alignment/ex_10-21/ansrate_pf-pmi_constraint_2019-10-21-12.txt")
b.table <- read.table("../../Alignment/new_psa/ansrate_pmi_2019-10-23.txt")

upper.list <- list()
lower.list <- list()

upper <- 0
lower <- 0
same <- 0
for (i in 1:110) {
  
  if (a.table$V2[i] > b.table$V2[i]) {
    upper <- upper + 1
    if (1) {
      diff <- paste(as.character(a.table$V1[i]), a.table[i, 2], b.table[i, 2], a.table[i, 2] - b.table[i, 2])
      print(diff)
      cat("\n")
      upper.list <- c(upper.list, diff)
    }
  }
  
  if (a.table$V2[i] < b.table$V2[i]) {
    lower <- lower + 1
    if (1) {
      diff <- paste(as.character(a.table$V1[i]), a.table[i, 2], b.table[i, 2], b.table[i, 2] - a.table[i, 2])
      print(diff)
      cat("\n")
      lower.list <- c(lower.list, diff)
    }
  }
  
  if (a.table$V2[i] == b.table$V2[i])
    same <- same + 1
  
}

write.table(list2mat(upper.list), "upper.txt", quote=F)
write.table(list2mat(lower.list), "lower.txt", quote=F)
