module Route
    exposing
        ( Path
        , Query
        , Route(..)
        , isEqualPath
        , modifyUrl
        , newUrl
        , route
        )

import Dict exposing (Dict)
import Navigation exposing (Location)
import Parser
import Route.Parser as Parser


type Route
    = View Path Query
    | BadUrl String


type alias Path =
    List String


type alias Query =
    Dict String String


route : Location -> Route
route { hash } =
    case Parser.run Parser.route hash of
        Ok { paths, queries } ->
            View paths (Dict.fromList queries)

        Err _ ->
            BadUrl hash


routeToString : Route -> String
routeToString route =
    case route of
        View paths stories ->
            String.concat
                [ "#/"
                , String.join "/" paths
                , "?"
                , Dict.toList stories
                    |> List.map (\( k, v ) -> String.join "=" [ k, v ])
                    |> String.join "&"
                ]

        BadUrl bad ->
            bad


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl


newUrl : Route -> Cmd msg
newUrl =
    routeToString >> Navigation.newUrl


isEqualPath : Route -> Route -> Bool
isEqualPath route1 route2 =
    case ( route1, route2 ) of
        ( View path1 _, View path2 _ ) ->
            path1 == path2

        _ ->
            False
