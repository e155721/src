library(Biostrings)

# make a matrix that it all elements are -1 and it diagonals are 0
vowel <- scan("vowel.txt", character(), quote = "")
consonant <- scan("consonant.txt", character(), quote = "")
symbols <- c(vowel, consonant)

# search an alphabet in the "symbols"
for (i in 1:length(letters)) {
  pattern <- paste("^", letters[i], "$", sep="")
  rlt <- symbols[grep(pattern, symbols)]
  rlt <- paste(letters[i], "->", rlt, sep="")
  print(rlt)
}

# seach a symbol in the "symbols"
haveX <- symbols[grep("x", symbols)]
haveOne <- symbols[grep("1", symbols)]
haveTwo <- symbols[grep("2", symbols)]
haveThree <- symbols[grep("3", symbols)]
haveCologne <- symbols[grep(":", symbols)]

makeVecSet <- function()
{
  minX <- c("px", "pjx", "tx", "tjx", "tsx", "ts2x", "kx", "kjx", "kwx")
  minOne <- c("dz1", "s1")
  minTwo <- c("i2", "i2:", "e2", "e2:", "o2", "s2", "z2", "n2")
  minThree <- c("ts3")
  minCologne <- c("i2:", "e:", "e2:", "a:", "o:", "u:", "n2:")
  minOther <- c("-1")
  
  # make a vector by above symbols
  u <- c(minX, minOne, minTwo, minThree, minCologne, minOther)
  
  # duplication check in the elements of vector "u"
  dup <- duplicated(u)
  u <- u[!dup]
  
  # replace
  substitutionArray <- LETTERS
  storingArray <- c()
  for (i in 1:length(u)) {
    storingArray[i] <- u[i]
    u[i] <- substitutionArray[i]
  }
  
  vecSet <- list(storingArray, u )
  return(vecSet)
}
