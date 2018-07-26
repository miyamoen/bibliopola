module Element.Util exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)


maybeOnClick : Maybe msg -> Attribute v msg
maybeOnClick maybe =
    case maybe of
        Just msg ->
            onClick msg

        Nothing ->
            classList []
