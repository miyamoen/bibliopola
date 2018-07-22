module Molecule.ViewItem exposing (..)

import Bibliopola exposing (..)
import Color.Pallet exposing (Pallet(..))
import Dummy
import Element exposing (..)
import Element.Attributes exposing (..)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Types exposing (..)


view : Zipper (View s v) -> MyElement s v
view zipper =
    let
        { name, state } =
            Zipper.current zipper

        depth =
            List.length <| Zipper.breadCrumbs zipper
    in
    el Box [ width fill, vary (PalletVar Blue) (state == Focused) ] <|
        row None
            [ spacing 5 ]
            [ icon state (Zipper.isEmpty zipper)
            , el Text
                [ vary (PalletVar <| textPallet state) True
                , moveRight <| toFloat depth * 10
                ]
              <|
                text name
            ]


icon : State -> Bool -> MyElement s v
icon state isLeaf =
    el Text [ vary (PalletVar <| textPallet state) True ] <|
        case ( state, isLeaf ) of
            ( Close, False ) ->
                text "+"

            ( Open, False ) ->
                text "-"

            ( Selected, False ) ->
                text "-"

            ( Focused, False ) ->
                text "+"

            ( _, True ) ->
                text "o"


textPallet : State -> Pallet
textPallet state =
    case state of
        Focused ->
            White

        _ ->
            Black


viewItem : View (Styles s) (Variation v)
viewItem =
    createViewItem "ViewItem" view [ "default" => Dummy.views ]


main : Program Never (Model (Styles s) (Variation v)) Msg
main =
    createMainfromViewItem [] viewItem
