library(readr)

source("lib/load_msa.R")
source("lib/load_data_processing.R")
source("lib/load_phylo.R")
source("parallel_config.R")


method     <- commandArgs(trailingOnly = TRUE)[1]
input_file <- commandArgs(trailingOnly = TRUE)[2]
output_dir <- commandArgs(trailingOnly = TRUE)[3]
cv_sep     <- commandArgs(trailingOnly = TRUE)[4]

read_me_path <- paste(output_dir, "/", "README.txt",  sep = "")

output_dir <- paste(output_dir, "/", "msa_", method, "/", sep = "")
if (!dir.exists(output_dir))
  dir.create(output_dir)

# MSAを実行する
word_list <- make_word_list(input_file)
msa_rlt   <- execute_msa(method, word_list, output_dir, cv_sep)

if ((method == "ld") || (method == "ld2")) {
  s        <- msa_rlt$s
  msa_list <- msa_rlt$msa_list
} else {
  pmi_list <- msa_rlt$pmi_list
  s        <- msa_rlt$s
  msa_list <- msa_rlt$msa_list

  # 更新後のスコア行列を保存する．
  write.csv(s, file = paste(output_dir, "/", "score_msa_", method, ".csv", sep = ""),
            quote = T, eol = "\n", na = "NA", row.names = T, fileEncoding = "UTF-8")
}

output_dir_aln <- paste(output_dir, "/alignment/", sep = "")

# MSAを出力する
output_msa(msa_list, output_dir_aln, ext = ".csv", excel = T)

# 発音記号列、MSAをRDataファイルに保存する
save(word_list, file = paste(output_dir, "/alignment/", "word_list.RData", sep = ""))
save(msa_rlt, file = paste(output_dir, "/alignment/", "msa_rlt.RData", sep = ""))

# Output the README.txt
read_me <- ("
・出力ディレクトリ
  出力ディレクトリの構成は，PSAとMSAでそれぞれ以下のようになっています．
  psa_アラインメントメソッド
  msa_アラインメントメソッド

  アラインメントメソッドは以下の3つがあります．
  ld:     Levenshtein距離
  pmi:    PMI
  pf-pmi: 素性PMI

  PSA，MSAともに，PMIと素性PMIのディレクトリには更新されたスコア行列がCSVファイルで保存されます．
  score_psa_アラインメントメソッド.csv
  score_msa_アラインメントメソッド.csv

  各ディレクトリの構成，及びファイル名は以下の通りです．

  |-alignment:       アラインメント結果が格納されます．
  |                  ファイルは3種類あります．
  |                  想定形.csv:      アラインメント結果CSVファイル
  |                  word_list.RData: 系統樹，系統樹ネットワークの作成に必要なファイル
  |                  msa_rlt.RData:   系統樹，系統樹ネットワークの作成に必要なファイル
  |-admixture_input: ADMIXTUREへの入力ファイルが格納されます．
  |-graph1:          単語ごとの系統樹，距離行列が格納されるディレクトリです．
  | |-tree:          単語ごとの系統樹が格納されます．
  | | |-rooted:      NJ法による有根系統樹が格納されます．（ファイル名：想定形_nj_rooted.pdf）
  | | |-unrooted:    NJ法による無根系統樹が格納されます．（ファイル名：想定形_nj_unrooted.pdf）
  | |-dist_mat:      単語ごとの距離行列が格納されます．（ファイル名：想定形_dist_mat.nexus）
  |-graph2:          全ての単語による系統樹，距離行列が格納されます．
                     ファイルは全部で3つあります．
                     dist_mat.nexus:   距離行列
                     nj_rooted.pdf:    NJ法による有根系統樹
                     nj_unrooted.pdf:  NJ法による無根系統樹")

write.table(read_me, file = read_me_path, quote = F, row.names = F, col.names = F)
