module Lambda.Parser
    (

    ) where

import Control.Applicative

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

instance Alternative Parser where
    -- empty :: Parser a
    -- (<|>) :: Parser a -> Parser a -> Parser a
    empty = Parser(const [])
    (<|>) p1 p2 = Parser(\s -> case parse p1 s of
        [] -> parse p2 s
        pair -> pair)


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

-- 失敗作
-- isStr :: String -> Parser String
-- isStr str = Parser(\s -> case s of
--     []  -> []
--     h:t -> case str of
--         [] -> []
--         h':t' ->
--             if h == h'
--             then isStr t
--             else [])
        -- [()]　を返す)

isWhite :: Parser Char
isWhite = do
    c <- item
    if c == ' ' then return c else empty

isStr :: String -> Parser String
isStr str = case str of
    [] -> return []
    h:t -> do
        _ <- many isWhite
        _ <- isChar h
        _ <- isStr t
        return $ h:t

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
