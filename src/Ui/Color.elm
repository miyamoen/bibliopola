module Ui.Color exposing
    ( uiColor, toCss
    , colors, toString, view
    , primary, secondary, basicary, font, fontLight
    , black, white, grey
    , irone, hinemos, benikakehanairo, akebono, oborotsuki, shinonome, aiirohatoba, shirahanoya, umoregi
    )

{-| 配色アイデア手帳　日本の美しい色と言葉
028 春分


## Utility

@docs uiColor, toCss


## Color

@docs colors, toString, view


### System

@docs primary, secondary, basicary, font, fontLight


### Mono

@docs black, white, grey


### Named

@docs irone, hinemos, benikakehanairo, akebono, oborotsuki, shinonome, aiirohatoba, shirahanoya, umoregi

-}

import Color exposing (..)
import Color.Convert
import Element exposing (Element, column, el, height, none, px, row, spacing, text, width)
import Element.Background as Background


uiColor : Color -> Element.Color
uiColor color =
    Color.toRgba color
        |> Element.fromRgb


toCss : Color -> String
toCss color =
    Color.Convert.colorToCssRgba color


colors : ( Color, List Color )
colors =
    ( irone
    , [ hinemos
      , benikakehanairo
      , akebono
      , oborotsuki
      , shinonome
      , aiirohatoba
      , shirahanoya
      , umoregi
      , white
      , black
      , grey
      ]
    )


toString : Color -> String
toString color =
    if color == irone then
        "irone"

    else if color == hinemos then
        "hinemos"

    else if color == benikakehanairo then
        "benikakehanairo"

    else if color == akebono then
        "primary/akebono"

    else if color == oborotsuki then
        "secondary/oborotsuki"

    else if color == shinonome then
        "shinonome"

    else if color == aiirohatoba then
        "aiirohatoba"

    else if color == shirahanoya then
        "basicary/shirahanoya"

    else if color == umoregi then
        "umoregi"

    else if color == grey then
        "font/grey"

    else if color == white then
        "fontLight/white"

    else if color == black then
        "black"

    else
        Color.toCssString color



---------------- system ----------------


primary : Color
primary =
    akebono


{-| -}
secondary : Color
secondary =
    oborotsuki


basicary : Color
basicary =
    shirahanoya


font : Color
font =
    grey


fontLight : Color
fontLight =
    white



---------------- mono ----------------


white : Color
white =
    rgb255 255 255 255


black : Color
black =
    rgb255 30 30 30


grey : Color
grey =
    rgb255 130 130 130



---------------- named ----------------


irone : Color
irone =
    rgb255 241 205 189


hinemos : Color
hinemos =
    rgb255 195 144 150


benikakehanairo : Color
benikakehanairo =
    rgb255 153 89 110


akebono : Color
akebono =
    rgb255 245 175 120


oborotsuki : Color
oborotsuki =
    rgb255 253 225 176


shinonome : Color
shinonome =
    rgb255 244 170 150


aiirohatoba : Color
aiirohatoba =
    rgb255 101 89 93


shirahanoya : Color
shirahanoya =
    rgb255 255 246 233


umoregi : Color
umoregi =
    rgb255 79 50 53



---------------- view ----------------


view : Element msg
view =
    row [ spacing 32 ]
        [ column [ spacing 8, Element.alignTop ]
            [ text "system"
            , labeled "primary" primary
            , labeled "secondary" secondary
            , labeled "basicary" basicary
            , labeled "font" font
            ]
        , column [ spacing 8, Element.alignTop ]
            [ text "mono"
            , labeled "white" white
            , labeled "grey" grey
            , labeled "black" black
            ]
        , column [ spacing 8, Element.alignTop ]
            [ text "named"
            , labeled "irone" irone
            , labeled "hinemos" hinemos
            , labeled "benikakehanairo" benikakehanairo
            , labeled "akebono" akebono
            , labeled "oborotsuki" oborotsuki
            , labeled "shinonome" shinonome
            , labeled "aiirohatoba" aiirohatoba
            , labeled "shirahanoya" shirahanoya
            , labeled "umoregi" umoregi
            ]
        ]


labeled : String -> Color -> Element msg
labeled label color =
    row [ spacing 16 ] [ viewBox color, text label ]


viewBox : Color -> Element msg
viewBox color =
    el
        [ width <| px 50
        , height <| px 50
        , Background.color <| uiColor color
        ]
    <|
        text ""
