module Atom.Icon.RuledLine exposing (Config, RuledLine(..), ruledLines, view)

import Atom.Constant as Constant exposing (iconSize)
import Color exposing (alphaGrey)
import Element exposing (..)
import Element.Border as Border


type RuledLine
    = Vertical
    | Horizontal
    | VerticalRight


ruledLines : List ( String, RuledLine )
ruledLines =
    [ Tuple.pair "vertical" Vertical
    , Tuple.pair "horisontal" Horizontal
    , Tuple.pair "verticalRight" VerticalRight
    ]


type alias Config a =
    { a | size : Int }


view : Config a -> RuledLine -> Element msg
view { size } ruledLine =
    let
        unit =
            iconSize size
    in
    el [ width <| px unit, height <| px unit ] <|
        case ruledLine of
            Vertical ->
                el
                    [ width <| px <| unit // 2 + borderWidth // 2
                    , height fill
                    , alignLeft
                    , Border.widthEach { zero | right = borderWidth }
                    , Border.color alphaGrey
                    ]
                    none

            Horizontal ->
                el
                    [ height <| px <| unit // 2 + borderWidth // 2
                    , width fill
                    , alignTop
                    , Border.widthEach { zero | bottom = borderWidth }
                    , Border.color alphaGrey
                    ]
                    none

            VerticalRight ->
                row [ width fill, height fill ]
                    [ el
                        [ width <| px <| unit // 2 + borderWidth // 2
                        , height fill
                        , Border.widthEach { zero | right = borderWidth }
                        , Border.color alphaGrey
                        ]
                        none
                    , el
                        [ height <| px <| unit // 2 + borderWidth // 2
                        , width fill
                        , alignTop
                        , Border.widthEach { zero | bottom = borderWidth }
                        , Border.color alphaGrey
                        ]
                        none
                    ]


borderWidth : Int
borderWidth =
    Constant.borderWidth 1


zero : { top : Int, right : Int, bottom : Int, left : Int }
zero =
    { top = 0
    , right = 0
    , bottom = 0
    , left = 0
    }
