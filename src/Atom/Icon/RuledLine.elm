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
    el [ width <| px unit, height <| px unit, Border.color alphaGrey ] <|
        case ruledLine of
            Vertical ->
                el
                    [ width <| px <| unit // 2
                    , alignLeft
                    , Border.widthEach { zero | right = borderWidth }
                    ]
                    none

            Horizontal ->
                el
                    [ height <| px <| unit // 2
                    , alignTop
                    , Border.widthEach { zero | bottom = borderWidth }
                    ]
                    none

            VerticalRight ->
                row []
                    [ el
                        [ width <| px <| unit // 2
                        , Border.widthEach { zero | right = borderWidth }
                        ]
                        none
                    , el
                        [ height <| px <| unit // 2
                        , alignTop
                        , Border.widthEach { zero | bottom = borderWidth }
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
