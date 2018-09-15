module Organism.BookPage exposing (view)

import Atom.Constant exposing (fontSize, space)
import Element exposing (..)
import Element.Font as Font
import Model.Book as Book
import Model.Shelf as Shelf
import Molecule.BookToggle as BookToggle
import Molecule.ShelfItem as ShelfItem
import Organism.FrontCover as FrontCover
import Types exposing (Msg(..), Shelf)


view : Shelf -> Element Msg
view shelf =
    let
        book =
            Shelf.book shelf
    in
    column [ width fill, height fill, spacing <| space 3 ]
        [ row [ width fill, spacing <| space 4 ]
            [ BookToggle.view shelf
            , el [ Font.size <| fontSize 3 ] <|
                text <|
                    String.join "/" [ Book.title book, Shelf.pathString shelf ]
            ]
        , if Book.hasNoPage book then
            Shelf.openChirdren shelf
                |> List.map ShelfItem.view
                |> column [ spacing <| space 3 ]

          else if Book.isOpen book then
            Book.storiesPage book
                |> Maybe.withDefault
                    (el [ centerX, centerY ] <| text "PAGE NOT FOUND")

          else
            Book.frontCover book
                |> Maybe.withDefault (FrontCover.view shelf)
        ]
