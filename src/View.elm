module View exposing (view)

import Element exposing (layout)
import Html exposing (Html)
import Page.Main
import Types exposing (Model, Msg)


view : Model -> Html Msg
view model =
    layout [] <| Page.Main.view model
