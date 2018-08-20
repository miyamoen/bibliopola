module Organism.BookPage exposing (view)

import Element exposing (..)
import Lazy
import Model.Book as Book
import Model.Shelf as Shelf
import Route exposing (Path, Query)
import Types exposing (..)


view : Path -> Model s v -> BibliopolaElement s v
view path model =
    let
        book =
            model.shelf
                |> Shelf.takeBook path

        page =
            if Maybe.map Book.isStoryMode book |> Maybe.withDefault False then
                Maybe.andThen Book.currentPage book
            else
                Maybe.andThen Book.frontCover book
    in
    page
        |> Maybe.map Lazy.force
        |> Maybe.map (Element.mapAll identity Child ChildVar)
        |> Maybe.withDefault
            (textLayout Text [] [ text "PAGE NOT FOUND" ])
