module Color exposing (alphaGrey, black, blue, colors, grey, greyBlue, toCss, white)

import Element exposing (Color, rgb255, rgba255, toRgb)


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
    rgb255 30 30 30


white : Color
white =
    rgb255 230 230 230


blue : Color
blue =
    rgb255 45 129 204


greyBlue : Color
greyBlue =
    rgb255 139 190 236


grey : Color
grey =
    rgb255 97 99 116


alphaGrey : Color
alphaGrey =
    rgba255 138 142 180 0.22
