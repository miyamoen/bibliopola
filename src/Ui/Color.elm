module Ui.Color exposing (aoki, primary, secondary, toCss, uiColor)

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


{-| 仮
-}
secondary : Color
secondary =
    rgb255 145 216 206


aoki : Color
aoki =
    rgb255 102 177 179
