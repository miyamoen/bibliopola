module Element.Util exposing (attributeWhenJust, onClickWhenJust, style, svgColor)

import Color
import Element exposing (..)
import Element.Events exposing (..)
import Html.Attributes as Attrs exposing (classList)


style : String -> String -> Attribute msg
style key value =
    htmlAttribute <| Attrs.style key value


svgColor : Color -> Attribute msg
svgColor color =
    style "fill" <| Color.toCss color


attributeWhenJust : Maybe a -> (a -> Attribute msg) -> Attribute msg
attributeWhenJust maybe toAttr =
    case maybe of
        Just a ->
            toAttr a

        Nothing ->
            htmlAttribute <| classList []


onClickWhenJust : Maybe msg -> Attribute msg
onClickWhenJust maybe =
    attributeWhenJust maybe onClick
