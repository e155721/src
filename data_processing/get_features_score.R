feature_consonant <- makeFeatureList("../Feature_Data/feature/子音入力数値一覧")
feature_vowel <- makeFeatureList("../Feature_Data/feature/母音入力数値一覧")
feature_score <- append(feature_consonant, feature_vowel)

consonant <- paste(read.table("../src/symbols/consonant.txt")$V1, collapse = " ")
vowel <- paste(read.table("../src/symbols/vowel.txt")$V1, collapse = " ")
symbols <- paste(consonant, vowel, collapse = "")
symbols <- as.vector(strsplit(symbols, " ")[[1]])

score_symbols <- vector(length = 118)
names(score_symbols) <- symbols

for (i in 1:118) {
  score_symbols[i] <- feature_score[[i]]
}
