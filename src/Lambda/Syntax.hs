module Lambda.Syntax
    (
     TermLambda(TermAbs, TermAp, TermVal, LambdaTermUnknown, TermVal2, TermEmpty),
    ) where

data TermLambda = TermVal String    -- 変数名
                | TermAbs (String, TermLambda)  -- 引数名、式の中
                | TermAp (TermLambda, [TermLambda]) -- TermAbs、代入する値
                | TermVal2 (String, TermLambda)
                | TermEmpty
                | LambdaTermUnknown
                deriving (Show, Eq)
