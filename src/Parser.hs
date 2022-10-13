module Parser
    (
        Parser,
        parse,
        parseProgram
    ) where

import Data.Char
import Control.Applicative
import Syntax ( Term(TermFalse, TermUnknown), Term(TermTrue) )

-- Parser type
newtype Parser a = Parser(String -> [(a, String)])

-- Functor implementation
instance Functor Parser where
    -- fmap :: (a -> b) -> Parser a -> Parser b
    fmap f a = Parser(\str -> case parse a str of
            []    -> []
            [(a', str')] -> [(f a', str')])

-- Applicative implementation
instance Applicative Parser where
    -- pure :: a -> Parser a
    -- <*>  :: Parser(a -> b) -> Parser a -> Parser b
    pure a = Parser(\s -> [(a, s)])
    (<*>) f a = Parser (\str -> case parse f str of
        [] -> []
        [(g, out)] -> parse (fmap g a) out
        )

-- Monad implementation
instance Monad Parser where
    -- return :: a -> Parser a
    -- >>= :: Parser a -> (a -> Parser b) -> Parser b
    return a = Parser(\s -> [(a, s)])
    (>>=) pa f = Parser(\str -> case parse pa str of
        [] -> []
        [(a', str')] -> parse (f a') str'
        ) 

-- 選択を行う Alternative 型クラスの実装
instance Alternative Parser where
    -- empty :: Parser a
    -- (<|>) :: Parser a -> Parser a -> Parser a
    empty = Parser(const [])
    (<|>) p1 p2 = Parser(\s -> case parse p1 s of
        [] -> parse p2 s
        pair -> pair)

sat :: (Char -> Bool) -> Parser Char
sat cond = do
        c <- item
        if cond c then return c else empty

isDigitChar :: Parser Char
isDigitChar = sat isDigit

isChar :: Char -> Parser Char
isChar c = sat (== c) -- == を部分適用したものを渡している.

lower :: Parser Char
lower = sat isLower

alphanum :: Parser Char
alphanum = sat isAlphaNum

num :: Parser Char
num = sat isDigit

-- Parser a を String -> [(a, String)] に変換するhelper
parse :: Parser a -> String -> [(a, String)]
parse p = let (Parser p') = p in p'

-- 引数のstringにmatchするparserを生成.
string :: String -> Parser String
string str = case str of
    [] -> return []
    (h:t) -> do
        -- MEMO: Parserの中身を書いていることに注意(直感と絶妙に反するんだよなあ)
        _ <- isChar h
        _ <- string t
        return (h:t)
    
-- 先頭の1つの文字だけを返すもっともprimitiveなparser
item :: Parser Char
item = Parser (\s -> case s of
    [] -> []
    (h:t) -> [(h, t)]
    )

ident :: Parser String
ident = do
    x  <- lower
    xs <- many alphanum
    return (x: xs)

nat :: Parser Int
nat = do
    xs <- some num
    return (read xs) -- readを使うことで、Intにキャストできる？

int :: Parser Int
int = do
    head <- item
    num <- some num
    case head of
        '-' -> return (- (read num))
        _   -> return (read (head:num))

natural :: Parser Int
natural = token nat

space :: Parser ()
space = do 
    many (sat isSpace)
    return ()

token :: Parser a -> Parser a
token p = do
    space
    v <- p
    space
    return v

symbol :: String -> Parser String
symbol xs = token (string xs)

-- program := true | false

parseTrue :: Parser Term
parseTrue = do
    _ <- symbol "true"
    return TermTrue

parseFalse :: Parser Term
parseFalse = do
    _ <- symbol "false"
    return TermFalse

parseIf :: Parser Term
parseIf = do
    _ <- symbol "if"
    cond <- parseTrue <|> parseFalse
    _ <- symbol "then"
    thn <- parseTrue <|> parseFalse
    _ <- symbol "else"
    els <- parseTrue <|> parseFalse
    case cond of
        TermTrue  -> return thn
        TermFalse -> return els
        _         -> return TermUnknown

parseProgram :: Parser Term
parseProgram = do
    parseTrue
    <|>
    parseFalse
    <|>
    parseIf
