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

-- 1文字読んでそれを結果として返すだけのparser
item :: Parser Char
item = Parser(\s -> case s of
    [] -> []
    h:t -> [(h, t)]
    )

isChar :: Char -> Parser Char
isChar c = Parser(\s -> case s of
    [] -> []
    h:t -> if h == c then [(h, t)] else [])

-- isChar' :: Char -> Bool
-- isChar' c = 

-- isStr :: String -> Parser String
-- isStr str = Parser(\s -> case s of
--     []  -> []
--     h:t -> case str of
--         [] -> []
--         h':t' ->
--             if h == h'
--             then isStr t
--             else []
--         -- [()]　を返す
--     )


    -- h:t -> do
    --     _ <- isChar h
    --     _ <- isStr t
    --     return (h:t))

-- 特定の単語まで読み進めるParser

parseLambdaAbs :: Parser String
parseLambdaAbs = Parser(\s -> [])

parseLambdaVal :: Parser String
parseLambdaVal = Parser(\s -> [])

parseLambdaApp :: Parser String
parseLambdaApp = Parser(\s -> [])
