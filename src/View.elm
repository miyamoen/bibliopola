module View exposing (..)

import Dict exposing (Dict)
import Element exposing (..)
import Html exposing (Html)
import Lazy
import Model.Views as Views
import Route exposing (Route(..))
import Styles exposing (styleSheet)
import Types exposing (..)


view : Model child childVar -> Html (Msg child childVar)
view model =
    layout (styleSheet model.styles) <|
        route model


route : Model s v -> MyElement s v
route model =
    case model.route of
        BadUrl bad ->
            text <| "BadUrl : " ++ bad

        View paths queries ->
            current paths queries model


current :
    List String
    -> Dict String String
    -> Model s v
    -> MyElement s v
current paths queries model =
    model.views
        |> Views.attemptOpenPath paths
        |> Views.openStory queries
        |> Maybe.map Lazy.force
        |> Maybe.withDefault (text "no view with this stories")
        |> Element.mapAll identity Child ChildVar
