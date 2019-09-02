module Ui.Color exposing
    ( aoki
    , basicary
    , black
    , font
    , grey
    , hukurasuzume
    , primary
    , samuzora
    , secondary
    , toCss
    , uiColor
    , wakana
    , white
    )

{-| 配色アイデア手帳　日本の美しい色と言葉
056 七草
-}

import Color exposing (..)
import Color.Convert
import Element


uiColor : Color -> Element.Color
uiColor color =
    Color.toRgba color
        |> Element.fromRgb


toCss : Color -> String
toCss color =
    Color.Convert.colorToCssRgba color


primary : Color
primary =
    aoki


{-| -}
secondary : Color
secondary =
    wakana


basicary : Color
basicary =
    rgb255 236 246 238


font : Color
font =
    grey


white : Color
white =
    rgb255 255 255 255


black : Color
black =
    rgb255 30 30 30


grey : Color
grey =
    rgb255 130 130 130


aoki : Color
aoki =
    rgb255 102 177 179


wakana : Color
wakana =
    rgb255 187 211 97


samuzora : Color
samuzora =
    rgb255 192 214 207


hukurasuzume : Color
hukurasuzume =
    rgb255 161 163 104
