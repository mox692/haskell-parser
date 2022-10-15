b:;
	stack build .

# use like `make r M="arith" S="test/data/1.txt"`
r:;
	.stack-work/dist/x86_64-osx/Cabal-3.4.1.0/build/haskell-parser-exe/haskell-parser-exe $(M) $(S)
