source("lib/load_phylo.R")
source("lib/load_pmi.R")

method     <- commandArgs(trailingOnly = TRUE)[1]
input_dir  <- commandArgs(trailingOnly = TRUE)[2]

# 出力ディレクトリを設定
output_dir <- paste(input_dir, "/", "msa_", method, "/", sep = "")

# 入力ディレクトリを指定されたメソッドのアラインメントが
# 保存されているディレクトリに再設定
input_dir   <- paste(input_dir, "/", "msa_", method, "/", "alignment", "/", sep = "")

# 入力データファイルの指定
input_file1 <- paste(input_dir, "msa_rlt.RData", sep = "")
input_file2 <- paste(input_dir, "word_list.RData", sep = "")

# 入力データの読み込み
load(input_file1)
load(input_file2)
s <- msa_rlt$s

# 全ての単語による系統樹，距離行列を出力する
phylo_all_word(word_list, method, s, output_dir)
