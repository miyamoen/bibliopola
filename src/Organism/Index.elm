module Organism.Index exposing (..)

import Bibliopola exposing (..)
import Dict exposing (Dict)
import Dummy
import Organism.ViewItem as ViewItem
import Organism.ViewTree as ViewTree
import Styles exposing (styles)
import Types exposing (..)


tree : ViewTree (Styles s) (Variation v)
tree =
    createEmptyViewTree "Organism"
        |> insertViewItem viewItem
        |> insertViewItem viewItemTree


viewItem : ViewItem (Styles s) (Variation v)
viewItem =
    createViewItem2 "ViewItem"
        (\path query -> ViewItem.view path query Dummy.model)
        ( "path", [ "empty" => [] ] )
        ( "query", [ "empty" => Dict.empty ] )
        |> withDefaultVariation (ViewItem.view [] Dict.empty Dummy.model)


viewItemTree : ViewItem (Styles s) (Variation v)
viewItemTree =
    createEmptyViewItem "ViewTree"
        |> withDefaultVariation (ViewTree.view Dummy.model)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewTree styles tree
