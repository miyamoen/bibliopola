module Route exposing (Paths, Queries, Route(..), route)

import Dict exposing (Dict)
import Navigation exposing (Location)
import Parser
import Route.Parser as Parser


type Route
    = View Paths Queries
    | BadUrl String


type alias Paths =
    List String


type alias Queries =
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
