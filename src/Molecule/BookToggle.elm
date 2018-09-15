module Molecule.BookToggle exposing (view)

import Atom.Constant exposing (space)
import Atom.Icon
import Atom.Icon.Book as Book
import Atom.Icon.OpenBook as OpenBook
import Atom.Toggle as Toggle
import Color
import Element exposing (..)
import Element.Events exposing (onClick)
import Model.Book as Book
import Model.Shelf as Shelf
import Types exposing (..)


view : Shelf -> Element Msg
view shelf =
    let
        isOpen =
            Shelf.mapBook Book.isOpen shelf
    in
    row
        [ spacing <| space 1
        , onClick <| SetShelf <| Shelf.updateBook Book.toggle shelf
        ]
        [ Book.view <|
            iconConfig <|
                if isOpen then
                    Color.alphaGrey

                else
                    Color.grey
        , Toggle.view { label = Nothing, onClick = Nothing } isOpen
        , OpenBook.view <|
            iconConfig <|
                if isOpen then
                    Color.blue

                else
                    Color.alphaGrey
        ]


iconConfig : Color -> Atom.Icon.Config {} msg
iconConfig color =
    { onClick = Nothing, color = color, size = 2 }
