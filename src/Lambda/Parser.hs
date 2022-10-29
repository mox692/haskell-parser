module Lambda.Parser
    (
parseLambda,
parseLambdaAbs,
parseLambdaApp,
getTermLambda,
parseLambdaProgram
    ) where

import Control.Applicative
import Data.Char
import Text.Printf()
import Lambda.Syntax (TermLambda(TermAbs, TermEmpty, TermVals), TermLambda(TermVal), TermLambda(TermAp), TermLambda(TermVals), TermLambda(LambdaTermUnknown), getTermVal)

newtype Parser a = Parser(String -> [(a, String)])

getTermLambda :: [(TermLambda, String)] -> TermLambda
getTermLambda a = case a of
    [(t, _)] -> t
    _ -> LambdaTermUnknown

-- helper
parseLambda :: Parser a -> String -> [(a, String)]
parseLambda p = case p of
    Parser x -> x

instance Functor Parser where
    -- fmap :: (a -> b) -> Parser a -> Parser b
    fmap f p = Parser(\s -> case parseLambda p s of
            [(a, s')] -> [(f a, s')]
            _        -> []
        )

instance Applicative Parser where
    -- pure :: a -> Parser a
    -- (<*>) :: Parser (a -> b) -> Parser a -> Parser b
    pure a = Parser(\s -> [(a, s)])
    (<*>) f a = Parser(\s -> case parseLambda f s of
        [(f', s')] -> case parseLambda a s' of
            [(a', s'')] -> [(f' a', s'')]
            _ -> []
        _ -> []
        )

instance Monad Parser where
    -- return :: a -> Parser a
    -- (>>=)  :: Parser a -> (a -> Parser b) -> Parser b
    return a = Parser(\s -> [(a, s)])
    (>>=) a f = Parser(\s -> case parseLambda a s of
        [(a', s')] -> parseLambda (f a') s'
        _ -> [])

instance Alternative Parser where
    -- empty :: Parser a
    -- (<|>) :: Parser a -> Parser a -> Parser a
    empty = Parser(const [])
    (<|>) p1 p2 = Parser(\s -> case parseLambda p1 s of
        [] -> parseLambda p2 s
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

startsWith :: Char -> String -> Bool
startsWith c s = case s of
    h:_ -> h == c
    _   -> False

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

parseLambdaVal :: Parser TermLambda
parseLambdaVal = do 
    _ <- many isWhite
    sym <- symbol
    -- TODO: もう少し綺麗に描きたい.
    if startsWith 'λ' sym || (sym == "")
    then empty
    else return $ TermVal sym

parseLambdaVals :: Parser [TermLambda]
parseLambdaVals = many parseLambdaVal -- MEMO: ここ

joinVals :: [TermLambda] -> TermLambda
joinVals vals = case vals of
    h:t -> TermVals (getTermVal h, joinVals t)
    _ -> TermEmpty

parseVal :: Parser TermLambda
parseVal = do 
    -- TODO: ここをもう少し綺麗に
    res <- joinVals <$> parseLambdaVals
    if res == TermEmpty
    then empty
    else return res

-- TODO: 複数引数に対応
parseLambdaAbs :: Parser TermLambda
parseLambdaAbs = do
    _ <- isMatchStr "λ"
    c <- symbol
    _ <- isMatchChar '.'
    t <- parseLambdaAbs
         <|>
         parseVal
    return  (TermAbs (c, t))

parseLambdaApp :: Parser TermLambda
parseLambdaApp = do
    _ <- isMatchChar '('
    ab <- parseLambdaAbs
    _ <- isMatchChar ')'
    val <- many parseLambdaVal
    return $ TermAp (ab, val)

parseLambdaProgram ::  Parser TermLambda
parseLambdaProgram = do
    parseVal -- MEMO: これがAbsを食べてしまってる
    <|>
    parseLambdaAbs
    <|>
    parseLambdaApp
