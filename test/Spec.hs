
import Arith.Eval
import Arith.Parser
import Arith.Syntax ( Term(TermFalse), Term(TermUnknown), Term(TermTrue) )
import Lambda.Syntax (TermLambda(TermAbs), TermLambda(TermVal), TermLambda(LambdaTermUnknown), TermLambda(TermVal2), TermLambda(TermEmpty))
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
        ("A TermVal is parsed correctly1", "x",  TermVal2 ("x", TermEmpty)),
        ("A TermVal is parsed correctly2", "foo",  TermVal2 ("foo", TermEmpty)),
        ("A TermVal is parsed correctly3", "x y z",  TermVal2 ("x", TermVal2 ("y", TermVal2("z" , TermEmpty)))),
        ("A invalid TermVal is parsed correctly", "λaaa",  LambdaTermUnknown),

        -- Lambda Abs
        ("A TermAbs is parsed correctly 1", "λx.x", TermAbs("x", TermVal2 ("x", TermEmpty))),
        ("A TermAbs is parsed correctly 2", "λx. y", TermAbs("x", TermVal2 ("y", TermEmpty))),
        ("A nested TermAbs is parsed correctly 1", "λx.λy.x y", TermAbs("x", TermAbs ("y", TermVal2 ("x", TermVal2 ("y", TermEmpty))))),
        -- ("A nested TermAbs is parsed correctly 2", "λx.x λy.x y", TermAbs("x", TermAbs ("y", TermVal "xy")))

        -- Lambda App
        ("A Lambda App is parsed correctly 1", "(λx.x) t", TermVal "t"),
        ("A Lambda App is parsed correctly 2", "(λx.x) t u", TermVal "t u"),
        ("A Lambda App is parsed correctly 3", "(λx.λy.λz x y z) s t", TermAbs("z", TermVal2 ("s", TermEmpty))),  -- λz. s t z
        ("A Lambda App is parsed correctly 4", "(λx.x) (λy.x y) u", TermAbs("y", TermVal2 ("u", TermVal2("y", TermEmpty)))) -- λy.u y
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
