module Organism.BookPage exposing (view)

import Element exposing (..)
import Lazy
import Maybe.Extra
import Model.Book as Book
import Model.Shelf as Shelf
import Route exposing (Path, Query)
import Types exposing (..)


view : Path -> Query -> Model s v -> BibliopolaElement s v
view paths queries model =
    let
        book =
            model.shelf
                |> Shelf.takeBook paths
    in
    Maybe.Extra.or
        (Maybe.andThen Book.currentPage book)
        (Maybe.andThen Book.frontCover book)
        |> Maybe.map Lazy.force
        |> Maybe.map (Element.mapAll identity Child ChildVar)
        |> Maybe.withDefault
            (textLayout Text [] [ text "PAGE NOT FOUND" ])
