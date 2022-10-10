module Syntax
   (
    Term(TermTrue, TermFalse)
   ) where 

data Term = TermTrue
          | TermFalse
          deriving Show
