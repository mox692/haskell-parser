
import Arith.Eval
import Arith.Parser
import Arith.Syntax ( Term(TermFalse, TermUnknown), Term(TermTrue) )
import Lambda.Syntax (TermLambda(TermAbs), TermLambda(TermVal), TermLambda(TermAp))
import Lambda.Parser
import Lambda.Eval
import Text.Printf

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
lambdaAssert :: (String, TermLambda) -> String
lambdaAssert pair
    | got == expected = "✅ OK"
    | otherwise = printf "❌ Expect %s, but got %s" (show expected) (show got)
    where got = evalLambda $ parseLambda parseLambdaAbs input
          (input , expected) = pair


lambdaTestCase :: [(String, TermLambda)]
lambdaTestCase =
    [
        ("λx.x", TermAbs("x", TermVal "x")),
        ("λx.y", TermAbs("x", TermVal "y"))
        -- ("λx.x y", TermValue("y"))
        -- ("λx.xyz a", TermValue("ayz")),
        -- ("λx.λy.xy a", TermValue("λy.ay"))
    ]

main :: IO ()
main = do
    putStrLn "test Start"
    -- TODO: mapMのことを調べる
    -- https://stackoverflow.com/questions/5289779/printing-elements-of-a-list-on-new-lines
    mapM_ putStrLn arithResult
    mapM_ putStrLn lambdaResult
        where arithResult  = fmap arithAssert arithTestCase
              lambdaResult = fmap lambdaAssert lambdaTestCase
