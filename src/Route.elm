module Route exposing (parse)

import List.Extra as List
import Maybe.Extra as Maybe
import Types exposing (Route(..))
import Url exposing (Url)


parse : Url -> Route
parse url =
    case preparePath url.path of
        [] ->
            TopRoute

        "pages" :: rest ->
            case List.unconsLast rest of
                Just ( pagePath, bookPaths ) ->
                    case ( Url.percentDecode pagePath, List.map Url.percentDecode bookPaths |> Maybe.combine ) of
                        ( Just pagePath_, Just bookPaths_ ) ->
                            PageRoute { pagePath = pagePath_, bookPaths = bookPaths_ }

                        _ ->
                            BrokenRoute <| Url.toString url

                Nothing ->
                    NotFoundRoute <| Url.toString url

        _ ->
            NotFoundRoute <| Url.toString url


preparePath : String -> List String
preparePath path =
    case String.split "/" path of
        "" :: segments ->
            removeFinalEmpty segments

        segments ->
            removeFinalEmpty segments


removeFinalEmpty : List String -> List String
removeFinalEmpty segments =
    case segments of
        [] ->
            []

        "" :: [] ->
            []

        segment :: rest ->
            segment :: removeFinalEmpty rest
