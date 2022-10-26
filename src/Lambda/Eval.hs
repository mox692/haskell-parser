module Lambda.Eval
    (
        evalLambda
    ) where
import Lambda.Syntax (TermLambda(TermAbs, TermVal2), TermLambda(TermVal), TermLambda(LambdaTermUnknown))


evalLambda :: [(TermLambda, String)] -> TermLambda
evalLambda t = case t of
    [(TermVal s, _)] -> _evalLambda $ TermVal s
    [(TermVal2 (s, next), _)] -> _evalLambda $ TermVal2 (s, next)
    [(TermAbs (s, lambda), _)] -> _evalLambda $ TermAbs (s, lambda)
    _ -> LambdaTermUnknown

_evalLambda :: TermLambda -> TermLambda
_evalLambda t = case t of
    TermVal s -> TermVal s
    TermVal2 s -> TermVal2 s
    TermAbs (s, lambda) -> TermAbs (s, _evalLambda lambda)
    _ -> LambdaTermUnknown
