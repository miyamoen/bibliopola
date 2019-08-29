module Route exposing (parse)

import Maybe.Extra as Maybe
import Types exposing (Route(..))
import Url exposing (Url)


parse : Url -> Route
parse url =
    case preparePath url.path of
        [] ->
            TopRoute

        "pages" :: pageKey :: bookKeys ->
            case ( Url.percentDecode pageKey, List.map Url.percentDecode bookKeys |> Maybe.combine ) of
                ( Just pageKey_, Just bookKeys_ ) ->
                    PageRoute pageKey_ bookKeys_

                _ ->
                    BrokenRoute <| Url.toString url

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
