module Main (main) where

import System.Environment
import Text.Printf
import Arith.Main

main :: IO ()
main = do
  args <- getArgs
  case args of
    [mode, sourceFile] -> case mode of
      "arith" -> arithMain sourceFile
      _       -> printf "invalid mode specified, %s\n" mode
    [] -> printf "no args found.\n"
    _ -> printf "invalid args are found, args: %s\n" $ show args

