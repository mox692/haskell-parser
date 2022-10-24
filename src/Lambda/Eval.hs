module Lambda.Eval
    (
        evalLambda
    ) where
import Lambda.Syntax (TermLambda(TermAbs), TermLambda(TermVal), TermLambda(LambdaTermUnknown))


evalLambda :: [(TermLambda, String)] -> TermLambda
evalLambda t = case t of
    [(TermVal s, _)] -> _evalLambda $ TermVal s
    [(TermAbs (s, lambda), _)] -> _evalLambda $ TermAbs (s, lambda)
    _ -> LambdaTermUnknown

_evalLambda :: TermLambda -> TermLambda
_evalLambda t = case t of
    TermVal s -> TermVal s
    TermAbs (s, lambda) -> TermAbs (s, _evalLambda lambda)
    _ -> LambdaTermUnknown
