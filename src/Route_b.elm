module Route exposing (fromBool, parse, toBool, url)

import Parser
import Route.Parser as Parser
import Types exposing (ParsedRoute)
import Url exposing (Url)
import Url.Builder as Builder exposing (Root(..))


parse : Url -> Maybe ParsedRoute
parse { query, fragment } =
    let
        path =
            case fragment of
                Just str ->
                    Parser.run Parser.path str
                        |> Result.map Just
                        |> Result.withDefault Nothing

                Nothing ->
                    Just []

        queryList =
            case query of
                Just str ->
                    Parser.run Parser.query str
                        |> Result.map Just
                        |> Result.withDefault Nothing

                Nothing ->
                    Just []
    in
    Maybe.map2 ParsedRoute path queryList


url : ParsedRoute -> String
url { path, query } =
    Builder.custom Relative
        []
        (List.map (\( k, v ) -> Builder.string k v) query)
        (String.join "/" path |> Just)


fromBool : Bool -> String
fromBool bool =
    case bool of
        True ->
            "true"

        False ->
            "false"


toBool : String -> Maybe Bool
toBool string =
    case string of
        "true" ->
            Just True

        "false" ->
            Just False

        _ ->
            Nothing
