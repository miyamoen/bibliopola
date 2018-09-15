module Organism.BookPage exposing (view)

import Atom.Constant exposing (fontSize, space)
import Atom.Toggle as Toggle
import Element exposing (..)
import Element.Font as Font
import Model.Book as Book
import Model.Shelf as Shelf
import Organism.FrontCover as FrontCover
import Types exposing (Msg(..), Shelf)


view : Shelf -> Element Msg
view shelf =
    column [ width fill, height fill, spacing <| space 3 ]
        [ row [ width fill, spacing <| space 4 ]
            [ Toggle.view
                { label = "Book Open"
                , onClick = \_ -> SetShelf <| Shelf.updateBook Book.toggle shelf
                }
              <|
                Shelf.mapBook Book.isOpen shelf
            , el [ Font.size <| fontSize 3 ] <| text <| "/" ++ Shelf.pathString shelf
            ]
        , Shelf.book shelf
            |> Book.currentPage
            |> Maybe.withDefault (FrontCover.view shelf)
        ]
