module Ui exposing (view)

import Browser
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Input
import Html exposing (Html)
import List.Extra as List
import SelectList exposing (SelectList)
import Types exposing (..)
import Ui.Basic exposing (..)
import Ui.Basic.Card as Card
import Ui.Basic.Radio as Radio
import Ui.Basic.Select as Select


view : Model -> Html Msg
view model =
    layout [] none
