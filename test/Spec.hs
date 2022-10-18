
import Arith.Eval
import Arith.Parser
import Arith.Syntax
import Text.Printf
import Syntax (Term(TermFalse, TermTrue))

--
-- Arith
--
arithAssert :: (String, Term) -> String
arithAssert pair
    | got == expected = "✅ OK"
    | otherwise = printf "❌ Expect %s, but got %s" (show expected) (show got)
    where got = eval $ parse parseProgram input
          (input , expected) = pair
-- TODO:arithAssert = eval . parse parseProgram "iinput " だとうまくいかない理由が謎

arithTestCase :: [(String, Term)]
arithTestCase =
    [
        ("true", TermTrue),
        ("false", TermFalse),
        ("@@@", TermUnknown)
    ]
 
--
-- Lambda
--
lambdaTestCase :: [(String, Term)]
lambdaTestCase =
    [
        ("λx.x", TermValue("λx.x")),
        ("λx.x y", TermValue("y")),
        ("λx.xyz a", TermValue("ayz")),
        ("λx.λy.xy a", TermValue("λy.ay"))
    ]

main :: IO ()
main = do
    putStrLn "test Start"
    -- TODO: mapMのことを調べる
    -- https://stackoverflow.com/questions/5289779/printing-elements-of-a-list-on-new-lines
    mapM_ putStrLn arithResult
        where arithResult = fmap arithAssert arithTestCase
