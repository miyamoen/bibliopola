module Color.Pallet exposing (Pallet(..), color, css, pallets)

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


css : Pallet -> String
css pallet =
    color pallet
        |> colorToCssRgba


colorToCssRgba : Color -> String
colorToCssRgba cl =
    let
        { red, green, blue, alpha } =
            Color.toRgb cl
    in
    cssColorString "rgba"
        [ toString red
        , toString green
        , toString blue
        , toString alpha
        ]


cssColorString : String -> List String -> String
cssColorString kind values =
    kind ++ "(" ++ String.join ", " values ++ ")"
