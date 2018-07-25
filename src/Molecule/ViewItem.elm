module Molecule.ViewItem exposing (..)

import Bibliopola exposing (..)
import Color.Pallet exposing (Pallet(..))
import Dummy
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Model.Views as Views exposing (..)
import Styles exposing (styles)
import Types exposing (..)


view : Zipper (View s v) -> MyElement s v
view zipper =
    let
        { name, state } =
            Zipper.current zipper

        depth =
            List.length <| Zipper.breadCrumbs zipper
    in
    el Box [ width fill, onClick (SetViews <| Views.toggleTree zipper) ] <|
        row None
            [ spacing 5, moveRight <| toFloat depth * 30 ]
            [ icon state (Zipper.isEmpty zipper)
            , el Text [ vary (PalletVar <| textPallet state) True ] <|
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

            ( _, True ) ->
                text "o"


textPallet : State -> Pallet
textPallet state =
    case state of
        Open ->
            Blue

        Close ->
            Black


viewItem : View (Styles s) (Variation v)
viewItem =
    createViewItem "ViewItem"
        view
        ( "views"
        , [ "root" => Dummy.views
          , "ham" => Views.attemptOpenPath [ "ham" ] Dummy.views
          , "egg" => Views.attemptOpenPath [ "egg" ] Dummy.views
          , "boiled_egg" => Views.attemptOpenPath [ "egg", "boiled" ] Dummy.views
          ]
        )
        |> withDefaultVariation (view Dummy.views)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewItem styles viewItem
