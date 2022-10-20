module Lambda.Parser
    (

    ) where

import Control.Applicative
import Data.Char
import Text.Printf
import Lambda.Syntax (Term(TermAbs), Term(TermVal), Term(TermAp))

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

isChar :: Parser Char
isChar = do
    c <- item
    if isAlpha c then return c else empty

isMatchChar :: Char -> Parser Char
isMatchChar c = Parser(\s -> case s of
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

isMatchStr :: String -> Parser String
isMatchStr str = case str of
    [] -> return []
    h:t -> do
        _ <- many isWhite
        _ <- isMatchChar h
        _ <- isMatchStr t
        return $ h:t

symbol :: Parser String
symbol = do many isChar

parseLambdaVal :: Parser Term
parseLambdaVal = do 
    _ <- many isWhite
    TermVal <$> symbol

-- TODO: 複数引数に対応
parseLambdaAbs :: Parser Term
parseLambdaAbs = do
    _ <- isMatchStr "λ"
    c <- symbol
    _ <- isMatchChar '.'
    t <- parseLambdaAbs
         <|>
         parseLambdaVal
    return  (TermAbs (c, t))

parseLambdaApp :: Parser Term
parseLambdaApp = do
    ab <- parseLambdaAbs
    val <- many parseLambdaVal
    return $ TermAp (ab, val)
