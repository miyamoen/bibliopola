module ParserTest exposing (testPath, testQuery)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Parser exposing (run)
import Route.Parser exposing (..)
import Test exposing (..)


pathOk : String -> List String -> () -> Expectation
pathOk input res _ =
    Expect.equal (run path input) (Ok res)


pathErr : String -> () -> Expectation
pathErr input _ =
    Expect.err (run path input)


testPath : Test
testPath =
    describe "path parser test"
        [ test "path1" <| pathOk "path1" [ "path1" ]
        , test "path1/" <| pathOk "path1/" [ "path1" ]
        , test "/path1" <| pathErr "/path1"
        , test "path1/path2" <| pathOk "path1/path2" [ "path1", "path2" ]
        , test "path1/path2/" <| pathOk "path1/path2/" [ "path1", "path2" ]
        , test "path1?a=2" <| pathErr "path1?a=2"
        , test "pa?th1" <| pathErr "pa?th1"
        , test "pa?/th1" <| pathErr "pa?/th1"
        , test "path_-1/" <| pathOk "path_-1/" [ "path_-1" ]
        , test "/" <| pathOk "/" []
        , test "empty" <| pathOk "" []
        , test "path//" <| pathErr "path//"
        , test "/path//path2" <| pathErr "/path//path2"
        ]


queryOk : String -> List ( String, String ) -> () -> Expectation
queryOk input res _ =
    Expect.equal (run query input) (Ok res)


queryErr : String -> () -> Expectation
queryErr input _ =
    Expect.err (run query input)


testQuery : Test
testQuery =
    describe "query parser test"
        [ test "empty" <| queryOk "" []
        , test "hoge" <| queryErr "hoge"
        , test "hoge?a=3" <| queryErr "hoge?a=3"
        , test "a=3" <| queryOk "a=3" [ ( "a", "3" ) ]
        , test "a=3&" <| queryErr "a=3&"
        , test "a=3&b=" <| queryErr "a=3&b="
        , test "a=3&huga=hoge" <|
            queryOk "a=3&huga=hoge" [ ( "a", "3" ), ( "huga", "hoge" ) ]
        ]
