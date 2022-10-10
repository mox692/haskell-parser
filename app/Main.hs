module Main (main) where

import System.Environment
import Parser
import Eval
import Text.Printf

main :: IO ()
main =
  do args <- getArgs
     case args of
       [sourceFile] -> 
          do 
            result <-  eval . parse parseProgram <$> readFile sourceFile
            -- MEMO: 下記3つの式と同じ意味
            -- * result <- readFile sourceFile <&> (eval . parse parseProgram)
            -- * result <- (parse parseProgram <$> readFile sourceFile) >>= (\t -> return $ eval t)
            -- * result <- readFile sourceFile >>= return . eval . parse parseProgram
            printf "file name   : %s\n" sourceFile
            printf "eval result : %s\n" $ show result

       [] -> printf "no args found.\n"
       _  -> printf "invalid args are found, args: %s\n" $ show args
