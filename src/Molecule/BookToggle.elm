module Molecule.BookToggle exposing (view)

import Atom.Toggle as Toggle
import Element exposing (..)
import Model.Book as Book
import Model.Shelf as Shelf
import Types exposing (..)


view : Shelf -> Element Msg
view shelf =
    Toggle.view
        { label = "Book Open"
        , onClick = \_ -> SetShelf <| Shelf.updateBook Book.toggle shelf
        }
    <|
        Shelf.mapBook Book.isOpen shelf
