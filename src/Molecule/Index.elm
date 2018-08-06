module Molecule.Index exposing (..)

import Bibliopola exposing (..)
import Dummy
import Model.ViewTree as ViewTree
import Molecule.Tabs as Tabs
import Molecule.ViewTreeLine as ViewTreeLine
import SelectList exposing (SelectList)
import Styles exposing (styles)
import Types exposing (..)


tree : ViewTree (Styles s) (Variation v)
tree =
    createEmptyViewTree "Molecule"
        |> insertViewItem viewItemTreeLine
        |> insertViewItem tabs


tabs : ViewItem (Styles s) (Variation v)
tabs =
    let
        view size =
            Tabs.view <|
                SelectList.fromLists [] StoryPanel <|
                    List.repeat size StoryPanel
    in
    createViewItem "Tabs"
        view
        ( "size", List.range 0 10 |> List.map (\num -> toString num => num) )
        |> withDefaultVariation (view 4)


viewItemTreeLine : ViewItem (Styles s) (Variation v)
viewItemTreeLine =
    createViewItem "ViewTreeLine"
        ViewTreeLine.view
        ( "views"
        , [ "root" => Dummy.views
          , "ham" => ViewTree.attemptOpenPath [ "ham" ] Dummy.views
          , "egg" => ViewTree.attemptOpenPath [ "egg" ] Dummy.views
          , "boiled_egg" => ViewTree.attemptOpenPath [ "egg", "boiled" ] Dummy.views
          ]
        )
        |> withDefaultVariation (ViewTreeLine.view Dummy.views)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewTree styles tree
