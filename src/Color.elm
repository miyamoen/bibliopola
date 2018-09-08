module Color exposing (alphaGrey, black, blue, colors, grey, toCss, white)

import Element exposing (Color, rgb, rgba, toRgb)


toCss : Color -> String
toCss color =
    let
        record =
            toRgb color
    in
    String.concat
        [ "rgba("
        , String.join ","
            [ String.fromInt <| round <| record.red * 255
            , String.fromInt <| round <| record.green * 255
            , String.fromInt <| round <| record.blue * 255
            , String.fromFloat record.alpha
            ]
        , ")"
        ]


colors : List ( String, Color )
colors =
    [ Tuple.pair "black" black
    , Tuple.pair "white" white
    , Tuple.pair "blue" blue
    , Tuple.pair "grey" grey
    , Tuple.pair "alphaGrey" alphaGrey
    ]


black : Color
black =
    rgb 30 30 30


white : Color
white =
    rgb 230 230 230


blue : Color
blue =
    rgb 45 129 204


grey : Color
grey =
    rgb 100 100 100


alphaGrey : Color
alphaGrey =
    rgba 138 142 180 0.22
