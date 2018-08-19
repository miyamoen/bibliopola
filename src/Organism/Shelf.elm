module Organism.Shelf exposing (..)

import Element.Attributes exposing (..)
import Element.Keyed exposing (column)
import Model.Shelf as Shelf
import Molecule.ShelfLine as ShelfLine
import Types exposing (..)


view : Model child childVar -> BibliopolaElement child childVar
view { shelf } =
    column None [ spacing 5 ] <|
        List.map line <|
            Shelf.openRecursively shelf


line : Shelf s v -> ( String, BibliopolaElement s v )
line tree =
    Shelf.pathString tree => ShelfLine.view tree
