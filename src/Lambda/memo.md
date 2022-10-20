* lambda計算のみを扱った系を作る.

### 手順
* 構文の定義
  * 変数
  * lambda抽象
  * 関数適用
* Parserの定義
  * 文字列を、上で定義した構文に変換する
* Evalの定義
  * Paserの生成物を受け取り、それらを簡約して値に変換する.

### サポートする機能
以下はlambda計算が扱えるようになった上で、という前提.
* Bool
* 自然数
* 数値演算
* tuple
* List

### 考慮
* lambda計算とはいえ、考えうる算術を全てsupportする良いうよりは色々前提をおかないといけないかもしれない
  * 評価戦略とか
  * 関数適用は左結合であるとか

* multibyte charの情報源
  * https://stackoverflow.com/questions/36159921/haskell-convert-string-with-unicode-characters-to-chunks-of-64-bits
