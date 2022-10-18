module Lambda.Parser
    (

    ) where

newtype Parser a = Parser(String -> [(a, String)])

-- helper
parse :: Parser a -> String -> [(a, String)]
parse p = case p of
    Parser x -> x

instance Functor Parser where
    -- fmap :: (a -> b) -> Parser a -> Parser b
    fmap f p = Parser(\s -> case parse p s of
            []        -> []
            [(a, s')] -> [(f a, s')]
        )

instance Applicative Parser where
    -- pure :: a -> Parser a
    -- (<*>) :: Parser (a -> b) -> Parser a -> Parser b
    pure a = Parser(\s -> [(a, s)])
    (<*>) f a = Parser(\s -> case parse f s of
        [] -> []
        [(f', s')] -> case parse a s' of
            [] -> []
            [(a', s'')] -> [(f' a', s'')]
        )

instance Monad Parser where
    -- return :: a -> Parser a
    -- (>>=)  :: Parser a -> (a -> Parser b) -> Parser b
    return a = Parser(\s -> [(a, s)])
    (>>=) a f = Parser(\s -> case parse a s of
        [] -> []
        [(a', s')] -> parse (f a') s')
