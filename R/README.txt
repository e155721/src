# ディレクトリの説明
admixture: ADMIXTUREへの入力ファイルを生成するRスクリプト
ex_gap: LD，LD(features)におけるギャップペナルティーについての実験を行うRスクリプト
lib: 関数等の定義ファイル
verification: 検証実験のためのRスクリプト

# シェルスクリプトの説明
ex_gap.sh: 'ex_gap/'のRスクリプトを実行するためのスクリプト
admixture.sh: アドミクスチャー入力ファイル生成スクリプトの実行と結果の整理を行うためのスクリプト
verification_psa.sh: 各メソッドによるPSAについて，Rの検証実験スクリプトを実行するためのスクリプト
verification_msa.sh: 各メソッドによるMSAについて，Rの検証実験スクリプト，及びadmixture.shを実行するためのスクリプト

# ブランチの説明
lang/bulgarian: ブルガリア諸語を扱うために，音素素性としてPHOIBLEの音素素性を使用する
lang/ryukyuan: 琉球諸語を扱うために，制約条件として子音と母音の間へのギャップ挿入を禁止する
pf-pmi/features: PF-PMI1，PF-PMI2，PF-PMI3において，「音なし」については音素素性の種類を考慮しない
pf-pmi/normalizing: PF-PMI1，PF-PMI2，PF-PMI3において，子音と母音の素性PMIの正規化を分けずに行う

ex/bul: ブルガリア諸語における検証実験 ('master'に'lang/bulgarian'，'pf-pmi/features'，'pf-pmi/normalizing'をマージ)
ex/ryukyu1: 琉球諸語における検証実験1 ('master'に'lang/ryukyuan'をマージ)
ex/ryukyu2: 琉球諸語における検証実験2 ('master'に'lang/ryukyuan'，'pf-pmi/features'をマージ)
ex/ryukyu3: 琉球諸語における検証実験3 ('master'に'lang/ryukyuan'，'pf-pmi/features'，'pf-pmi/normalizing'をマージ)
