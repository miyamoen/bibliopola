module Atom.Folder exposing (Config, view, viewItem)

import Bibliopola exposing (..)
import Color.Pallet as Pallet exposing (Pallet(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Util exposing (maybeOnClick)
import Styles exposing (styles)
import Svg exposing (..)
import Svg.Attributes exposing (d, viewBox)
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
                    [ path
                        [ d pathString ]
                        []
                    ]
                ]


pathString : String
pathString =
    """M496.145,112.909c-9.735-9.758-23.396-15.855-38.278-15.846H212.761c-3.011,0-5.931-1.147-8.15-3.235
 l0.016,0.026l-43.07-40.39c-10.04-9.405-23.272-14.643-37.024-14.643h-70.4c-14.882-0.008-28.552,6.096-38.278,15.856
 C6.096,64.403-0.008,78.072,0,92.954v326.092c-0.008,14.882,6.096,28.551,15.855,38.277c9.726,9.759,23.396,15.863,38.278,15.856
 h403.734c14.882,0.008,28.552-6.096,38.278-15.856c9.759-9.726,15.863-23.395,15.855-38.277V151.187
 C512.008,136.305,505.904,122.636,496.145,112.909z M466.282,427.452c-2.228,2.194-5.065,3.481-8.414,3.49H54.133
 c-3.35-0.008-6.187-1.296-8.414-3.49c-2.186-2.219-3.473-5.057-3.481-8.406V92.954c0.008-3.35,1.295-6.187,3.481-8.415
 c2.228-2.186,5.065-3.472,8.414-3.481h70.4c3.028,0,5.923,1.147,8.142,3.218l43.062,40.381l0.016,0.025
 c10.015,9.363,23.239,14.618,37.007,14.618h245.106c3.35,0.008,6.196,1.295,8.414,3.481c2.186,2.219,3.474,5.057,3.481,8.406
 v267.859C469.756,422.395,468.468,425.233,466.282,427.452z"""


viewItem : View (Styles s) (Variation v)
viewItem =
    let
        config pallet =
            { pallet = pallet
            , onClick = Just "Folder clicked!"
            , size = 256
            }
    in
    createViewItem "Folder"
        view
        ( "pallet"
        , List.map (\p -> toString p => config p) Pallet.pallets
        )
        |> withDefaultVariation (view <| config Black)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewItem styles viewItem
