module Lambda.Syntax
    (
     TermLambda(TermAbs, TermAp, TermVal, LambdaTermUnknown, TermVals, TermEmpty),
     getTermVal
    ) where

data TermLambda = TermVal String    -- 変数名
                | TermAbs (String, TermLambda)  -- 引数名、式の中
                | TermAp (TermLambda, [TermLambda]) -- TermAbs、代入する値
                | TermVals (String, TermLambda)
                | TermEmpty
                | LambdaTermUnknown
                deriving (Show, Eq)

getTermVal :: TermLambda -> String
getTermVal (TermVal str) = str
getTermVal _ = ""
