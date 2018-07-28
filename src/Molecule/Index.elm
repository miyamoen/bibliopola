module Molecule.Index exposing (..)

import Bibliopola exposing (..)
import Dummy
import Model.ViewTree as ViewTree
import Molecule.ViewTreeLine as ViewTreeLine
import Styles exposing (styles)
import Types exposing (..)


tree : ViewTree (Styles s) (Variation v)
tree =
    createEmptyViewTree "Molecule"
        |> insertViewItem viewItemTreeLine


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
