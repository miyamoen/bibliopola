module Molecule.Index exposing (..)

import Bibliopola exposing (..)
import Dummy
import Model.Views as Views
import Molecule.ViewTreeLine as ViewItemTreeLine
import Styles exposing (styles)
import Types exposing (..)


tree : ViewTree (Styles s) (Variation v)
tree =
    createEmptyViewTree "Molecule"
        |> insertViewItem viewItemTreeLine


viewItemTreeLine : ViewItem (Styles s) (Variation v)
viewItemTreeLine =
    createViewItem "ViewItemTreeLine"
        ViewItemTreeLine.view
        ( "views"
        , [ "root" => Dummy.views
          , "ham" => Views.attemptOpenPath [ "ham" ] Dummy.views
          , "egg" => Views.attemptOpenPath [ "egg" ] Dummy.views
          , "boiled_egg" => Views.attemptOpenPath [ "egg", "boiled" ] Dummy.views
          ]
        )
        |> withDefaultVariation (ViewItemTreeLine.view Dummy.views)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewTree styles tree
