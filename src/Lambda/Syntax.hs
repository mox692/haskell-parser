module Lambda.SYntax
    (

    ) where

data Term = TermVal      -- λ Value
            | TermAbs    -- λ Abstruction
            | TermAp     -- λ Apply
