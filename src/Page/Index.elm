module Page.Index exposing (..)

import Bibliopola exposing (..)
import Dummy
import Page.Main as Main
import Styles exposing (styles)
import Types exposing (..)


tree : ViewTree (Styles s) (Variation v)
tree =
    createEmptyViewTree "Page"
        |> insertViewItem mainPage


mainPage : ViewItem (Styles s) (Variation v)
mainPage =
    createEmptyViewItem "Main"
        |> withDefaultVariation (Main.view Dummy.model)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewTree styles tree
