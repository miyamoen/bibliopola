module Molecule.ShelfItem exposing (view)

import Atom.Constant exposing (fontSize, iconSize, space)
import Atom.Icon.Book as Book
import Atom.Icon.Books as Books
import Atom.Icon.Caret as Caret
import Atom.Icon.RuledLine as RuledLine
import Color
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Font as Font
import Model.Book as Book
import Model.Shelf as Shelf
import Route
import Types exposing (Msg(..), Shelf)


view : Shelf -> Element Msg
view shelf =
    row
        [ spacing <| space 1
        , pointer
        , onClick <| SetShelf <| Shelf.updateBook Book.toggleShelf shelf
        ]
    <|
        ruledLine shelf
            ++ [ caret shelf
               , icon shelf
               , el [ Font.size <| fontSize 2 ] <|
                    text <|
                        Shelf.mapBook Book.title shelf
               ]


ruledLine : Shelf -> List (Element msg)
ruledLine shelf =
    let
        depth =
            Shelf.depth shelf
    in
    case depth of
        0 ->
            []

        1 ->
            [ RuledLine.view { size = 1 } RuledLine.VerticalRight ]

        _ ->
            List.repeat (depth - 1)
                (RuledLine.view { size = 1 } RuledLine.Vertical)
                ++ [ RuledLine.view { size = 1 } RuledLine.VerticalRight ]


caret : Shelf -> Element msg
caret shelf =
    if not <| Shelf.hasShelves shelf then
        RuledLine.view { size = 1 } RuledLine.Horizontal

    else
        Caret.view { size = 1, color = Color.grey, onClick = Nothing } <|
            if Shelf.mapBook Book.shelfIsOpen shelf then
                Caret.Down

            else
                Caret.Right


icon : Shelf -> Element msg
icon shelf =
    (if Shelf.hasShelves shelf then
        Books.view

     else
        Book.view
    )
    <|
        { size = 1, color = Color.grey, onClick = Nothing }
