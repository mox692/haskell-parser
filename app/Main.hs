module Main (main) where

import System.Environment
import Parser
import Text.Printf

main :: IO ()
main =
  do args <- getArgs
     case args of
       [sourceFile] -> 
        -- Ref: https://hackage.haskell.org/package/parsec-3.1.15.1/docs/Text-Parsec.html#v:parse
          do 
            res <- parse parseProgram <$> readFile sourceFile
            printf "file name   : %s\n" sourceFile
            printf "parse result: %s\n" $ show res

       _ -> putStrLn "Usage: arith <sourceFile>"
