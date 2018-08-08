module Atom.Ban exposing (Config, view)

import Color.Pallet as Pallet exposing (Pallet(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Util exposing (maybeOnClick)
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
    """M256,0C114.613,0,0,114.615,0,256s114.613,256,256,256c141.383,0,256-114.615,256-256S397.383,0,256,0z
 M99.594,144.848L367.15,412.406C335.754,434.781,297.402,448,256,448c-105.871,0-192-86.131-192-192
 C64,214.596,77.217,176.244,99.594,144.848z M412.404,367.15L144.848,99.594C176.242,77.219,214.594,64,256,64
 c105.867,0,192,86.131,192,192C448,297.404,434.781,335.756,412.404,367.15z"""
