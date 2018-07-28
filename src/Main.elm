module Main exposing (..)

import Atom.Index
import Bibliopola exposing (..)
import Molecule.Index
import Organism.Index
import Page.Index
import Styles exposing (styles)
import Types exposing (..)


tree : ViewTree (Styles s) (Variation v)
tree =
    createEmptyViewTree "Bibliopola"
        |> insertViewTree Atom.Index.tree
        |> insertViewTree Molecule.Index.tree
        |> insertViewTree Organism.Index.tree
        |> insertViewTree Page.Index.tree


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewTree styles tree
