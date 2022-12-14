module Arith.Eval
    (
      eval
    ) where

import Arith.Syntax ( Term(TermFalse), Term(TermTrue), Term(TermUnknown) )

eval :: [(Term, String)] -> Term
eval t = case t of
    [(TermTrue , _)] -> TermTrue
    [(TermFalse, _)] -> TermFalse
    _                -> TermUnknown
