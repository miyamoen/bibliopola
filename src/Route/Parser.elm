module Route.Parser exposing (paths, queries, route)

import Parser exposing (..)


route : Parser { paths : List String, queries : List ( String, String ) }
route =
    oneOf
        [ succeed (\paths queries -> { paths = paths, queries = queries })
            |. hash
            |= paths
            |= oneOf [ queries, succeed [] ]
            |. end
        , Parser.map (always { paths = [], queries = [] }) end
        ]


paths : Parser (List String)
paths =
    oneOf
        [ repeat oneOrMore onePath
            |. oneOf [ slash, succeed () ]
        , Parser.map (always []) slash
        ]


onePath : Parser String
onePath =
    delayedCommitMap always
        (succeed identity
            |. slash
            |= string
        )
        (succeed ())


queries : Parser (List ( String, String ))
queries =
    oneOf
        [ delayedCommitMap (::)
            (succeed identity
                |. qmark
                |= oneQuery
            )
          <|
            repeat zeroOrMore
                (succeed identity
                    |. ampersand
                    |= oneQuery
                )
        , Parser.map (always []) qmark
        ]


oneQuery : Parser ( String, String )
oneQuery =
    succeed (,)
        |= string
        |. equal
        |= string



-- Symbol Parsers


string : Parser String
string =
    source <|
        ignore oneOrMore (\char -> String.all ((/=) char) "/?=&")


hash : Parser ()
hash =
    symbol "#"


slash : Parser ()
slash =
    symbol "/"


equal : Parser ()
equal =
    symbol "="


qmark : Parser ()
qmark =
    symbol "?"


ampersand : Parser ()
ampersand =
    symbol "&"
