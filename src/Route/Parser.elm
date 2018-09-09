module Route.Parser exposing (path, query)

import Parser exposing (..)


path : Parser (List String)
path =
    oneOf
        [ succeed [] |. chompIf ((==) '/')
        , sequence
            { start = ""
            , separator = "/"
            , end = ""
            , spaces = succeed ()
            , item = string
            , trailing = Optional
            }
        ]
        |. end


query : Parser (List ( String, String ))
query =
    sequence
        { start = ""
        , separator = "&"
        , end = ""
        , spaces = succeed ()
        , item = pair
        , trailing = Forbidden
        }
        |. end


pair : Parser ( String, String )
pair =
    succeed Tuple.pair
        |= string
        |. symbol "="
        |= string


string : Parser String
string =
    getChompedString <|
        succeed ()
            |. chompIf validChar
            |. chompWhile validChar


validChar : Char -> Bool
validChar c =
    Char.isAlphaNum c || c == '_' || c == '-'
