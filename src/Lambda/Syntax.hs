module Lambda.Syntax
    (
     TermLambda(TermAbs, TermAp, TermVal, TermUnknown)
    ) where

data TermLambda = TermVal String    -- 変数名
                | TermAbs (String, TermLambda)  -- 引数名、式の中
                | TermAp (TermLambda, [TermLambda]) -- TermAbs、代入する値
                | TermUnknown
                deriving (Show, Eq)
