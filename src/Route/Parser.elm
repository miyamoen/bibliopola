module Route.Parser exposing (path, query)

import Parser exposing (..)


path : Parser (List String)
path =
    sequence
        { start = "#/"
        , separator = "/"
        , end = ""
        , spaces = succeed ()
        , item = string
        , trailing = Optional
        }


query : Parser (List ( String, String ))
query =
    sequence
        { start = "?"
        , separator = "&"
        , end = ""
        , spaces = succeed ()
        , item = pair
        , trailing = Forbidden
        }


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
            |. chompIf Char.isAlpha
            |. chompWhile (\c -> Char.isAlphaNum c || c == '_' || c == '-')
