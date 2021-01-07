library(readr)

source("lib/load_exec_align.R")
source("lib/load_data_processing.R")
source("lib/load_phylo.R")
source("parallel_config.R")


method     <- commandArgs(trailingOnly = TRUE)[1]
input_file <- commandArgs(trailingOnly = TRUE)[2]
output_dir <- commandArgs(trailingOnly = TRUE)[3]
cv_sep     <- commandArgs(trailingOnly = TRUE)[4]

read_me_path <- paste(output_dir, "/", "README.txt",  sep = "")

output_dir <- paste(output_dir, "/", "psa_", method, "/", sep = "")
if (!dir.exists(output_dir))
  dir.create(output_dir)

# Execute the PSA.
word_list <- make_word_list(input_file)
psa_rlt   <- execute_psa(method, word_list, output_dir, cv_sep)

if (method == "ld") {
  s        <- psa_rlt$s
  psa_list <- psa_rlt$psa_list
} else {
  pmi_list <- psa_rlt$pmi_list
  s        <- psa_rlt$s
  psa_list <- psa_rlt$psa_list

  # Save the matrix of the PMIs and the scoring matrix.
  write.csv(s, file = paste(output_dir, "/", "score_msa_", method, ".csv", sep = ""),
            quote = T, eol = "\n", na = "NA", row.names = T, fileEncoding = "UTF-8")
}

output_dir_aln <- paste(output_dir, "/alignment/", sep = "")

# Output the PSAs.
output_psa(psa_list, output_dir = output_dir_aln, ext = ".csv", excel = T)

# Plot the phylogenetic trees and the networks.
Plot(psa_list, output_dir, method, s)

# Calculate the regional distance matrix.
make_region_dist(word_list, method, s, output_dir)

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

  各ディレクトリの構成，及びファイル名は以下の通りです．

  |-alignment:      アラインメント結果が格納されます．（ファイル名：語彙ID_想定形.csv）
  |-graph1:         単語ごとの系統樹・系統ネットワーク，距離行列が格納されるディレクトリです．
  | |-tree:         単語ごとの系統樹が格納されます．
  | | |-ave:        UPGMAによる系統樹が格納されます（NJ法による系統樹が作成できなかった場合）．
  | | | |-rooted:   単語ごとの有根系統樹が格納されます．（ファイル名：語彙ID_想定形_ave_rooted.pdf）
  | | | |-unrooted: 単語ごとの無根系統樹が格納されます．（ファイル名：語彙ID_想定形_ave_unrooted.pdf）
  | | |-nj:　　　　 NJ法による系統樹が格納されます．
  | | | |-rooted:   単語ごとの有根系統樹が格納されます．（ファイル名：語彙ID_想定形_nj_rooted.pdf）
  | | | |-unrooted: 単語ごとの無根系統樹が格納されます．（ファイル名：語彙ID_想定形_nj_unrooted.pdf）
  | |-dist_mat:     単語ごとの距離行列が格納されます．（ファイル名：語彙ID_想定形_dist_mat.nexus）
  | |-network:      単語ごとの系統ネットワークが格納されます．（ファイル名：語彙ID_想定形_nnet.pdf）
  |-graph2:         全単語の結果をまとめた系統樹・系統ネットワークが格納されます．
                    ファイルは全部で4つあります．
                    dist_mat.nexus:  距離行列
                    nj_rooted.pdf:   NJ法による有根系統樹
                    nj_unrooted.pdf: NJ法による無根系統樹
                    nnet.pdf:        系統ネットワーク")

write.table(read_me, file = read_me_path, quote = F, row.names = F, col.names = F)
