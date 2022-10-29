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

* 項の羅列(今はただのspace)か、関数適用(元々カッコで表現しようとしていた)に対して、何かルールを設けないといけなそう?

        -- 項の連結も `.` で表現する案
        -- このあたりから正直怪しい( (λx.λy.x) y で、yが引数なのか、(λx.λy.x y) なのかが不明瞭)
        -- ("A nested TermAbs is parsed correctly 1", "λx.λy.x y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        ("A nested TermAbs is parsed correctly 1", "λx.λy.x.y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        ("A nested TermAbs is parsed correctly 1", "λx.λy.x y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),

        -- これは λx.x内の項が x, λy.x, y の3つなのか、2つ x, λy.x y なのかの区別ができない
        -- ("A nested TermAbs is parsed correctly 2", "λx.x λy.x y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        ("A nested TermAbs is parsed correctly 2", "λx.x.λy.x.y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        ("A nested TermAbs is parsed correctly 2", "λx.x λy.x.y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),

        ("A nested TermAbs is parsed correctly 2", "λx.x.λy.y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        ("A nested TermAbs is parsed correctly 2", "λx.λy.y.x.(λz.z s).s", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        ("A nested TermAbs is parsed correctly 2", "λx x λy y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- これは?
        ("A nested TermAbs is parsed correctly 2", "(λx.x λy.x) y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- これは (λy.x y) を λx.x に適用してるのか、項が2つなのかの区別がつかない
        ("A nested TermAbs is parsed correctly 2", "λx.x (λy.x y)", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- これは (λy.x y) を λx.x に適用してるのか、項が2つなのかの区別がつかない
        ("A nested TermAbs is parsed correctly 2", "λx.x (λy.x y)", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),

* termAppを木構造的な感じで表現
