module Syntax
   (
    Term(TermTrue, TermFalse, TermUnknown)
   ) where 

data Term = TermTrue
          | TermFalse
          | TermIf(Term, Term, Term)
          | TermUnknown
          deriving Show
