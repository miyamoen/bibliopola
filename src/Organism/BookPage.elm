module Organism.BookPage exposing (view)

import Atom.Constant exposing (fontSize)
import Element exposing (..)
import Element.Font as Font
import Model.Book as Book
import Model.Shelf as Shelf
import Types exposing (Msg, Shelf)


view : Shelf -> Element Msg
view shelf =
    Shelf.book shelf
        |> Book.currentPage
        |> Maybe.withDefault
            (paragraph [ Font.size <| fontSize 2 ] [ text "PAGE NOT FOUND" ])
