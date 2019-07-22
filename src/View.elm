module View exposing (view)

import Element exposing (Element, layout)
import Html exposing (Html)
import Page.Main
import Types exposing (Model, Msg)


view : Maybe (Element String) -> Model -> Html Msg
view front model =
    layout [] <| Page.Main.view front model
