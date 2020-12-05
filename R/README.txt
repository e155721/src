・本プログラムは，発音記号列のアラインメントを行うためのプログラムです．
　ペアワイズアラインメント: 2本の配列間で行われるアラインメント
　マルチプルアラインメント: 3本以上の配列間で行われるアラインメント

・execution_psa ディレクトリに，ペアワイズアラインメントを実行するためのスクリプトがあります．
  execution_lv.R:     Levenshtein距離アラインメント
  execution_pmi.R:    PMIアラインメント
  execution_pf-pmi.R: PF-PMIアラインメント

・execution_msa ディレクトリに，マルチプルアラインメントを実行するためのスクリプトがあります．
  execution_msa_lv.R:     Levenshtein距離アラインメント
  execution_msa_pmi.R:    PMIアラインメント
  execution_msa_pf-pmi.R: PF-PMIアラインメント

・test.sh を実行することで，上記6つのスクリプトを実行することができます．

・各Rスクリプトは，引数として「入力ディレクトリ名」と「出力ディレクトリ名」の2つを必要とします．
  出力ディレクトリの中に，単語ごとのアラインメント結果が拡張子'.aln'を付けて保存されます．
  '.aln'という拡張子は便宜上のもので，中身はただのテキストファイルです．

・スクリプトの構成について．
  基本的に，全てのスクリプトは同じ構成になっています．
  例：execution_lv.R

  input_dir:  入力ディレクトリ
  output_dir: 出力ディレクトリ

  1. file_list <- GetPathList(input_dir)
  2. word_list <- make_word_list(file_list)
  3. psa_list <- psa_lv(word_list)
  4. OutputPSA(psa_list, file_list, output_dir)

  1. で入力ディレクトリ内の全てのファイルへのパスをリストとして取得します．
  2. で1で作成したリストのパスを参照し，各入力ファイルの発音記号列を取得します．
  3. で2のリストの発音記号列に対してアラインメントを行い，その結果をリストとして取得します．
  4. でアラインメント結果を，output_dir に指定したディレクトリへ，ファイルごとに書き出します．

  また，PMI，およびPF-PMIアラインメントでは，3は以下のようになっています．
  3. psa_list <- psa_pmi(word_list)$psa_list
   　psa_list <- psa_pf_pmi(word_list)$psa_list
  PMI，PF-PMIアラインメントでは，アラインメント結果の他に，スコア行列と呼ばれるものの更新も行っているため，
  psa_pmi，psa_pf_pmi 関数は，更新後のスコア行列も含め戻り値として出力します．
  従って，ここでは"$psa_list"によって，アラインメント結果のリストだけを取得しています．

  マルチプルアラインメントのスクリプトについても，同様になっています．
