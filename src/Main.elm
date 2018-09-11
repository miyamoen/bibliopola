module Main exposing (shelf)

import Atom.Index
import Bibliopola exposing (..)
import Molecule.Index
import Organism.Index
import Page.Index


main : Bibliopola.Program
main =
    fromShelf shelf


shelf : Shelf
shelf =
    emptyShelf "Bibliopola"
        |> addShelf Atom.Index.shelf
        |> addShelf Molecule.Index.shelf
        |> addShelf Organism.Index.shelf
        |> addShelf Page.Index.shelf
