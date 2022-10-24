
import Arith.Eval
import Arith.Parser
import Arith.Syntax ( Term(TermFalse), Term(TermUnknown), Term(TermTrue) )
import Lambda.Syntax (TermLambda(TermAbs), TermLambda(TermVal), TermLambda(LambdaTermUnknown))
import Lambda.Parser
import Lambda.Eval
import Text.Printf

--
-- Arith
--
arithAssert :: (String, String, Term) -> String
arithAssert pair
    | got == expected = caseName ++ "  ...  ✅ OK"
    | otherwise = printf "%s  ...  ❌ Expect %s, but got %s" caseName (show expected) (show got)
    where got = eval $ parse parseProgram input
          (caseName, input , expected) = pair
-- TODO:arithAssert = eval . parse parseProgram "iinput " だとうまくいかない理由が謎

arithTestCase :: [(String, String, Term)]
arithTestCase =
    [
        ("A TermTrue is parsed correctly", "true", TermTrue),
        ("A TermFalse is parsed correctly", "false", TermFalse),
        ("Illegal inputs are treated as Unknown", "@@@", TermUnknown)
    ]
 
--
-- Lambda
--
lambdaAssert :: (String, String, TermLambda) -> String
lambdaAssert pair
    | got == expected = caseName ++ "  ...  ✅ OK"
    | otherwise = printf "%s  ...  ❌ Expect %s, but got %s" caseName (show expected) (show got)
    where got = evalLambda $ parseLambda parseLambdaProgram input
          (caseName, input , expected) = pair


lambdaTestCase :: [(String, String, TermLambda)]
lambdaTestCase =
    [
        -- Lambda Val
        ("A TermVal is parsed correctly", "x",  TermVal "x"),
        ("A TermVal is parsed correctly", "foo",  TermVal "foo"),
        ("A invalid TermVal is parsed correctly", "λaaa",  LambdaTermUnknown),

        -- Lambda Abs
        ("A TermAbs is parsed correctly 1", "λx.x", TermAbs("x", TermVal "x")),
        ("A TermAbs is parsed correctly 2", "λx.y", TermAbs("x", TermVal "y"))
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
