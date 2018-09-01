module Model.Shelf exposing
    ( book
    , depth
    , hasShelves
    , mapCurrentBook
    , open
    , openAll
    , path
    , pathString
    , root
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
    if not <| mapCurrentBook Book.isOpen shelf then
        [ shelf ]

    else
        shelf
            :: (Zipper.openAll zipper
                    |> List.concatMap (Shelf >> openAll)
               )


mapCurrentBook : (Book -> a) -> Shelf -> a
mapCurrentBook f shelf =
    book shelf |> f


updateBook : (Book -> Book) -> Shelf -> Shelf
updateBook f (Shelf zipper) =
    Shelf <| Zipper.map f zipper


hasShelves : Shelf -> Bool
hasShelves (Shelf zipper) =
    not <| Zipper.isEmpty zipper


depth : Shelf -> Int
depth (Shelf zipper) =
    Zipper.breadcrumbs zipper
        |> List.length


path : Shelf -> ShelfPath
path (Shelf zipper) =
    Zipper.getPath Book.title zipper
        |> List.tail
        |> Maybe.withDefault []


pathString : Shelf -> String
pathString shelf =
    path shelf
        |> String.join "/"
