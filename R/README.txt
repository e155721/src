・本プログラムは，発音記号列のアラインメントを行うためのプログラムです．
　マルチプルアラインメント（MSA）: 3本以上の配列間で行われるアラインメント

・execution ディレクトリに，アラインメントを実行するためのスクリプトがあります．
  execution_msa.R: MSAを実行するためのスクリプト

・出力ディレクトリ
  出力ディレクトリは以下のようになっています．
  msa_アラインメントメソッド

  アラインメントメソッドには以下の6つがあります．
  ld:      Levenshtein距離
  ld2:     音素素性による重み付けを用いたLevenshtein距離
  pmi:     PMI
  pf-pmi1: 素性PMI1
  pf-pmi2: 素性PMI2
  pf-pmi3: 素性PMI3

  各ディレクトリの構成，及びファイル名は以下の通りです．

  |-alignment:       アラインメント結果が格納されます．（ファイル名：語彙ID_想定形.csv）
  |-admixture_input: ADMIXTUREへの入力ファイルが格納されます． 
  |-graph1:          単語ごとの系統樹，距離行列が格納されるディレクトリです．
  | |-tree:          単語ごとの系統樹が格納されます．
  | | |-ave:         UPGMAによる系統樹が格納されます（NJ法による系統樹が作成できなかった場合）．
  | | | |-rooted:    単語ごとの有根系統樹が格納されます．（ファイル名：語彙ID_想定形_ave_rooted.pdf）
  | | | |-unrooted:  単語ごとの無根系統樹が格納されます．（ファイル名：語彙ID_想定形_ave_unrooted.pdf）
  | | |-nj:　　　　  NJ法による系統樹が格納されます．
  | | | |-rooted:    単語ごとの有根系統樹が格納されます．（ファイル名：語彙ID_想定形_nj_rooted.pdf）
  | | | |-unrooted:  単語ごとの無根系統樹が格納されます．（ファイル名：語彙ID_想定形_nj_unrooted.pdf）
  | |-dist_mat:      単語ごとの距離行列が格納されます．（ファイル名：語彙ID_想定形_dist_mat.nexus）
  |-graph2:          全ての単語による系統樹，距離行列が格納されます．
                     ファイルは全部で3つあります．
                     dist_mat.nexus:   距離行列
                     nj_rooted.pdf:    NJ法による有根系統樹
                     nj_unrooted.pdf:  NJ法による無根系統樹

# シェルスクリプトについて
ryukyu.sh: 6つのメソッドそれぞれで，アラインメント，系統樹，距離行列の算出を行います．
ryukyu_ld: Levenshtein距離によるアラインメントと，系統樹，距離行列の算出を行います．
ryukyu_ld2: 音素素性による重み付けを用いたLevenshtein距離によるアラインメントと，系統樹，距離行列の算出を行います．
ryukyu_pmi: PMIによるアラインメントと，系統樹，距離行列の算出を行います．
ryukyu_pf-pmi1: PF-PMI1によるアラインメントと，系統樹，距離行列の算出を行います．
ryukyu_pf-pmi2: PF-PMI2によるアラインメントと，系統樹，距離行列の算出を行います．
ryukyu_pf-pmi3: PF-PMI3によるアラインメントと，系統樹，距離行列の算出を行います．

admixture.sh: ADMIXTUREへの入力ファイルを生成します．このスクリプトは'ryukyu.sh'，'ryukyu_*.sh'内で呼び出されます．

# ブランチについて
web-app/base: 'master'にある検証実験用のスクリプトを削除
              Webアプリケーション用のRスクリプトを追加 ('execution/')
              上記のRスクリプトを実行するためのシェルスクリプトを追加（'ryukyu.sh'）

web-app/ryukyu-lang: 'web-app/base'に以下3つのブランチをマージ
                     lang/ryukyuan: 琉球諸語を扱うために，制約条件として子音と母音の間へのギャップ挿入を禁止する
                     pf-pmi/features: PF-PMI1，PF-PMI2，PF-PMI3において，「音なし」については音素素性の種類を考慮しない
                     pf-pmi/normalizing: PF-PMI1，PF-PMI2，PF-PMI3において，子音と母音の素性PMIの正規化を分けずに行う

'execution/'に含まれるRスクリプト，及び'ryukyu.sh'以外のスクリプトに関わる変更は，
'master'から作成したブランチで行い，'master'にマージする．その後，'web-app/base'を'master'にrebaseする．
