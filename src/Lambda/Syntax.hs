module Lambda.Syntax
    (
     Term(TermAbs, TermAp, TermVal)
    ) where

data Term = TermVal String    -- 変数名
            | TermAbs (String, Term)  -- 引数名、式の中
            | TermAp (Term, [Term]) -- TermAbs、代入する値
            deriving Show
