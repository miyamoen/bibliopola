module Organism.ShelfTree exposing (view)

import Atom.Constant exposing (space)
import Element exposing (Element, spacing)
import Element.Keyed exposing (column)
import Model.Shelf as Shelf
import Molecule.ShelfItem as ShelfItem
import Types exposing (..)


view : Shelf -> Element Msg
view shelf =
    column [ spacing <| space 1 ] <|
        List.map item <|
            Shelf.openAll shelf


item : Shelf -> ( String, Element Msg )
item shelf =
    Tuple.pair (Shelf.pathString shelf) (ShelfItem.view shelf)
