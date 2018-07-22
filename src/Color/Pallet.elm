module Color.Pallet exposing (..)

import Color exposing (Color, rgb)


type Pallet
    = Black
    | White
    | Blue


pallets : List Pallet
pallets =
    [ Black, White, Blue ]


color : Pallet -> Color
color pallet =
    case pallet of
        Black ->
            rgb 30 30 30

        White ->
            rgb 230 230 230

        Blue ->
            rgb 45 129 204
