source("lib/load_phylo.R")
source("lib/load_pmi.R")

method     <- commandArgs(trailingOnly = TRUE)[1]
input_dir  <- commandArgs(trailingOnly = TRUE)[2]

# 出力ディレクトリを設定
output_dir <- input_dir
# 入力ディレクトリを，指定されたメソッドのアラインメント結果が
# 保存されているディレクトリに再設定
input_dir  <- paste(input_dir, "/", "msa_", method, "/", "alignment", "/", sep = "")
# 入力ファイルを指定
input_file <- paste(input_dir, "msa_rlt.RData", sep = "")

# アラインメント結果の読み込み
load(input_file)
s        <- msa_rlt$s
msa_list <- msa_rlt$msa_list

# MSAをPSAに分解する
psa_list <- ChangeListMSA2PSA(msa_list, s)

# 単語ごとの系統樹，距離行列を出力する
phylo_each_word(psa_list, output_dir, method, s)
