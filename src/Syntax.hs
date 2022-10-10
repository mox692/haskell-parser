module Syntax
   (
    Term(TermTrue, TermFalse, TermUnknown)
   ) where 

data Term = TermTrue
          | TermFalse
          | TermUnknown
          deriving Show
