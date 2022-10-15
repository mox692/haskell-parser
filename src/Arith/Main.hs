module Arith.Main
    (
        arithMain
    ) where

import Arith.Eval
import Arith.Parser
import Text.Printf

arithMain :: String -> IO ()
arithMain input = do
        result <-  eval . parse parseProgram <$> readFile input
        -- MEMO: 下記3つの式と同じ意味
        -- * result <- readFile sourceFile <&> (eval . parse parseProgram)
        -- * result <- (parse parseProgram <$> readFile sourceFile) >>= (\t -> return $ eval t)
        -- * result <- readFile sourceFile >>= return . eval . parse parseProgram
        printf "file name   : %s\n" input
        printf "eval result : %s\n" $ show result
