module Test.Route.Parser exposing (..)

import Expression exposing (..)
import Parser exposing (run)
import Route.Parser as RP exposing (..)
import Test exposing (Test, describe)


testRoute : Test
testRoute =
    describe "route parser test"
        [ "#/"
            ==> run route "#/"
            === Ok { paths = [], queries = [] }
        , "#" ==> isErr <| run route "#"
        , "#/path//?" ==> isErr <| run route "#/path//?"
        , "#/path/?hoge=3/" ==> isErr <| run route "#/path/?hoge=3/"
        , "#/?"
            ==> run route "#/?"
            === Ok { paths = [], queries = [] }
        , "#/path1/path2?hoge=3&huga=9"
            ==> run route "#/path1/path2?hoge=3&huga=9"
            === Ok
                    { paths = [ "path1", "path2" ]
                    , queries = [ ( "hoge", "3" ), ( "huga", "9" ) ]
                    }
        ]


testPaths : Test
testPaths =
    describe "paths parser test"
        [ "/path1" ==> Ok [ "path1" ] === run paths "/path1"
        , "/path1/" ==> Ok [ "path1" ] === run paths "/path1/"
        , "/path1/path2"
            ==> Ok [ "path1", "path2" ]
            === run paths "/path1/path2"
        , "/path1/path2/"
            ==> Ok [ "path1", "path2" ]
            === run paths "/path1/path2/"
        , "/path1?a=2" ==> Ok [ "path1" ] === run paths "/path1?a=2"
        , "/" ==> Ok [] === run paths "/"
        , "/path//" ==> Ok [ "path" ] === run paths "/path//"
        , "/path//path2" ==> Ok [ "path" ] === run paths "/path//path2"
        , "path" ==> isErr <| run paths "path"
        , "path/path1" ==> isErr <| run paths "path/path1"
        ]


testQueries : Test
testQueries =
    describe "queries parser test"
        [ "?" ==> Ok [] === run queries "?"
        , "empty" ==> isErr <| run queries ""
        , "hoge" ==> isErr <| run queries "hoge"
        , "hoge?a=3" ==> isErr <| run queries "hoge?a=3"
        , "?a=3" ==> Ok [ ( "a", "3" ) ] === run queries "?a=3"
        , "?a=3&" ==> isErr <| run queries "?a=3&"
        , "?a=3&b=" ==> isErr <| run queries "?a=3&b="
        , "?a=3&b=7"
            ==> Ok [ ( "a", "3" ), ( "b", "7" ) ]
            === run queries "?a=3&b=7"
        ]
