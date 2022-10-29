
import Arith.Eval
import Arith.Parser
import Arith.Syntax ( Term(TermFalse), Term(TermUnknown), Term(TermTrue) )
import Lambda.Syntax (TermLambda(TermAbs, TermEmpty), TermLambda(TermVal), TermLambda(LambdaTermUnknown), TermLambda(TermVals), TermLambda(TermEmpty))
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
        ("A TermVal is parsed correctly1", "x",  TermVals ("x", TermEmpty)),
        ("A TermVal is parsed correctly2", "foo",  TermVals ("foo", TermEmpty)),
        ("A invalid TermVal is parsed correctly", "λaaa",  LambdaTermUnknown),

        -- Lambda Abs
        ("A TermAbs is parsed correctly 1", "λx.x", TermAbs("x", TermVals ("x", TermEmpty))),
        ("A TermAbs is parsed correctly 2", "λx.y", TermAbs("x", TermVals ("y", TermEmpty))),
        -- このあたりから正直怪しい( (λx.λy.x) y で、yが引数なのか、(λx.λy.x y) なのかが不明瞭)
        ("A nested TermAbs is parsed correctly 1", "λx.λy.x.y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- これは λx.x内の項が x, λy.x, y の3つなのか、2つ x, λy.x y なのかの区別ができない
        ("A nested TermAbs is parsed correctly 2", "λx.x λy.x y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- これは?
        ("A nested TermAbs is parsed correctly 2", "(λx.λz.x.z) (λy.x) y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- これは (λy.x y) を λx.x に適用してるのか、項が2つなのかの区別がつかない
        ("A nested TermAbs is parsed correctly 2", "λx.x λy.x.y λy.x.y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- これは (λy.x y) を λx.x に適用してるのか、項が2つなのかの区別がつかない
        ("A nested TermAbs is parsed correctly 2", "λx.x.(λy.x.y t).λz.x.z", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),


        -- -- 項の連結も `.` で表現する案
        -- -- このあたりから正直怪しい( (λx.λy.x) y で、yが引数なのか、(λx.λy.x y) なのかが不明瞭)
        -- -- ("A nested TermAbs is parsed correctly 1", "λx.λy.x y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- ("A nested TermAbs is parsed correctly 1", "λx.λy.x.y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- ("A nested TermAbs is parsed correctly 1", "λx.λy.x y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),

        -- -- これは λx.x内の項が x, λy.x, y の3つなのか、2つ x, λy.x y なのかの区別ができない
        -- -- ("A nested TermAbs is parsed correctly 2", "λx.x λy.x y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- ("A nested TermAbs is parsed correctly 2", "λx.x.λy.x.y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- ("A nested TermAbs is parsed correctly 2", "λx.x λy.x.y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),

        -- ("A nested TermAbs is parsed correctly 2", "λx.x.λy.y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- ("A nested TermAbs is parsed correctly 2", "λx.λy.y.x.(λz.z s).s", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- ("A nested TermAbs is parsed correctly 2", "λx x λy y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- -- これは?
        -- ("A nested TermAbs is parsed correctly 2", "(λx.x λy.x) y", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- -- これは (λy.x y) を λx.x に適用してるのか、項が2つなのかの区別がつかない
        -- ("A nested TermAbs is parsed correctly 2", "λx.x (λy.x y)", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),
        -- -- これは (λy.x y) を λx.x に適用してるのか、項が2つなのかの区別がつかない
        -- ("A nested TermAbs is parsed correctly 2", "λx.x (λy.x y)", TermAbs("x", TermAbs ("y", TermVals ("x", TermVals ("y", TermEmpty))))),

        -- Lambda App

        ("A TermVal is parsed correctly3", "x y",  TermUnknown),
        ("A Lambda App is parsed correctly 1", "(λx.x) t", TermVal "t"),
        ("A Lambda App is parsed correctly 2", "(λx.x) t u", TermVal "t u"),
        ("A Lambda App is parsed correctly 2", "(λx.λy.x y) t u", TermVal "t u"),
        ("A Lambda App is parsed correctly 3", "(λx.λy.λz x y z) s t", TermAbs("z", TermVals ("s", TermEmpty))),  -- λz. s t z
        ("A Lambda App is parsed correctly 4", "(λx.x) (λy.x y) u", TermAbs("y", TermVals ("u", TermVals("y", TermEmpty)))) -- λy.u y
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
