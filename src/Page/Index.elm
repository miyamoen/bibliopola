module Page.Index exposing (..)

import Bibliopola exposing (..)
import Dummy
import Page.Main as Main
import Styles exposing (styles)
import Types exposing ((=>), Styles, Variation)


tree : ViewTree (Styles s) (Variation v)
tree =
    createEmptyViewTree "Page"
        |> insertViewItem mainPage


mainPage : ViewItem (Styles s) (Variation v)
mainPage =
    createEmptyViewItem "Main"
        |> withDefaultVariation (Main.view Dummy.model)


main : BibliopolaProgram (Styles s) (Variation v)
main =
    createProgramFromViewTree styles tree
