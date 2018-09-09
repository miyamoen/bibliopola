module Model.Shelf exposing
    ( attempt
    , book
    , depth
    , findPage
    , hasShelves
    , mapBook
    , open
    , openAll
    , path
    , pathString
    , root
    , route
    , updateBook
    )

import Dict exposing (Dict)
import Element exposing (Element)
import Model.Book as Book
import SelectList exposing (SelectList)
import Tree.Zipper as Zipper exposing (Zipper)
import Types exposing (..)


root : Shelf -> Shelf
root (Shelf zipper) =
    Shelf <| Zipper.root zipper


book : Shelf -> Book
book (Shelf zipper) =
    Zipper.current zipper


open : ShelfPath -> Shelf -> Maybe Shelf
open shelfPath (Shelf zipper) =
    Zipper.openPath
        (\pathPiece book_ -> Book.title book_ == pathPiece)
        shelfPath
        zipper
        |> Result.toMaybe
        |> Maybe.map Shelf


openAll : Shelf -> List Shelf
openAll ((Shelf zipper) as shelf) =
    if not <| mapBook Book.shelfIsOpen shelf then
        [ shelf ]

    else
        shelf
            :: (Zipper.openAll zipper
                    |> List.concatMap (Shelf >> openAll)
               )


findPage : ParsedRoute -> Shelf -> Maybe Shelf
findPage current shelf =
    root shelf
        |> open current.path
        |> Maybe.map (updateBook (Book.turn current.query))


attempt : (Shelf -> Maybe Shelf) -> Shelf -> Shelf
attempt f shelf =
    f shelf |> Maybe.withDefault shelf


mapBook : (Book -> a) -> Shelf -> a
mapBook f shelf =
    book shelf |> f


updateBook : (Book -> Book) -> Shelf -> Shelf
updateBook f (Shelf zipper) =
    Shelf <| Zipper.updateItem f zipper


hasShelves : Shelf -> Bool
hasShelves (Shelf zipper) =
    not <| Zipper.isEmpty zipper


depth : Shelf -> Int
depth (Shelf zipper) =
    Zipper.breadcrumbs zipper
        |> List.length


route : Shelf -> ParsedRoute
route shelf =
    { path = path shelf, query = mapBook Book.routeQuery shelf }


path : Shelf -> ShelfPath
path (Shelf zipper) =
    Zipper.getPath Book.title zipper
        |> List.tail
        |> Maybe.withDefault []


pathString : Shelf -> String
pathString shelf =
    path shelf
        |> String.join "/"
