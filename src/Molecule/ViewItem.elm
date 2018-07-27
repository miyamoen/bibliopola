module Molecule.ViewItem exposing (..)

import Atom.Caret as Caret
import Atom.File as File
import Atom.Folder as Folder
import Bibliopola exposing (..)
import Color.Pallet exposing (Pallet(..))
import Dict
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
    el Box [ width fill ] <|
        row None
            [ spacing 10, moveRight <| toFloat depth * 20, verticalCenter ]
            [ caret zipper
            , row None
                [ spacing 5, verticalCenter ]
                [ icon zipper, el Text [] <| text name ]
            ]


caret : Zipper (View s v) -> MyElement s v
caret zipper =
    let
        size =
            15
    in
    if Zipper.isEmpty zipper then
        el None [ width <| px size, height <| px size ] empty
    else
        Caret.view
            { size = size
            , pallet = Grey
            , onClick = Just <| \_ -> SetViews <| Views.toggleTree zipper
            }
        <|
            case .state <| Zipper.current zipper of
                Open ->
                    Caret.Down

                Close ->
                    Caret.Right


icon : Zipper (View s v) -> MyElement s v
icon zipper =
    (if Dict.isEmpty <| .variations <| Zipper.current zipper then
        Folder.view
     else
        File.view
    )
    <|
        { size = 15, pallet = Black, onClick = Nothing }


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
