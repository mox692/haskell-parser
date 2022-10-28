module Lambda.Eval
    (
        evalLambda
    ) where
import Lambda.Syntax (TermLambda(TermAbs, TermVals), TermLambda(TermVal), TermLambda(LambdaTermUnknown))


evalLambda :: [(TermLambda, String)] -> TermLambda
evalLambda t = case t of
    [(TermVal s, _)] -> _evalLambda $ TermVal s
    [(TermVals (s, next), _)] -> _evalLambda $ TermVals (s, next)
    [(TermAbs (s, lambda), _)] -> _evalLambda $ TermAbs (s, lambda)
    _ -> LambdaTermUnknown

_evalLambda :: TermLambda -> TermLambda
_evalLambda t = case t of
    TermVal s -> TermVal s
    TermVals s -> TermVals s
    TermAbs (s, lambda) -> TermAbs (s, _evalLambda lambda)
    _ -> LambdaTermUnknown
