module Atom.File exposing (Config, view, viewItem)

import Bibliopola exposing (..)
import Color.Pallet as Pallet exposing (Pallet(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Util exposing (maybeOnClick)
import Styles exposing (styles)
import Svg exposing (..)
import Svg.Attributes as Svg exposing (d, viewBox, x, y)
import Types exposing (..)


type alias Config a msg =
    { a
        | pallet : Pallet
        , onClick : Maybe msg
        , size : Float
    }


view : Config a msg -> Element (Styles s) (Variation v) msg
view { pallet, onClick, size } =
    el None
        [ inlineStyle
            [ "fill" => Pallet.css pallet
            , "cursor"
                => (Maybe.map (always "pointer") onClick
                        |> Maybe.withDefault ""
                   )
            ]
        , width <| px size
        , height <| px size
        , maybeOnClick onClick
        ]
    <|
        Element.html <|
            svg [ viewBox "0 0 512 512" ]
                [ g []
                    [ sentence "394.181"
                    , sentence "305.688"
                    , sentence "217.203"
                    , rect
                        [ x "262.546"
                        , y "128.725"
                        , Svg.width "107.636"
                        , Svg.height "21.82"
                        ]
                        []
                    , path
                        [ d pathString ]
                        []
                    ]
                ]


sentence : String -> Svg msg
sentence yString =
    rect
        [ x "141.818"
        , y yString
        , Svg.width "228.365"
        , Svg.height "21.82"
        ]
        []


pathString : String
pathString =
    """M411.626,0H222.758c-13.559,0-26.564,5.39-36.152,14.969L68.794,132.788
 c-9.59,9.587-14.976,22.596-14.976,36.156v296.5c0,25.67,20.889,46.556,46.56,46.556h311.247c25.667,0,46.556-20.886,46.556-46.556
 V46.542C458.182,20.878,437.292,0,411.626,0z M206.252,32.349v104.652c0,11.313-4.405,15.722-15.718,15.722H85.877L206.252,32.349z
 M432.002,465.444c0,11.237-9.146,20.372-20.376,20.372H100.378c-11.237,0-20.38-9.135-20.38-20.372V175.998h124.554
 c13.77,0,24.978-11.207,24.978-24.985V26.184h182.096c11.23,0,20.376,9.127,20.376,20.358V465.444z"""


viewItem : View (Styles s) (Variation v)
viewItem =
    let
        config pallet =
            { pallet = pallet
            , onClick = Just "File clicked!"
            , size = 256
            }
    in
    createViewItem "File"
        view
        ( "pallet"
        , List.map (\p -> toString p => config p) Pallet.pallets
        )
        |> withDefaultVariation (view <| config Black)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewItem styles viewItem
