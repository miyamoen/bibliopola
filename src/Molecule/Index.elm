module Molecule.Index exposing (shelf)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Dummy
import Element exposing (Element)
import Model.Shelf as Shelf
import Molecule.BookToggle as BookToggle
import Molecule.ShelfItem as ShelfItem
import Molecule.Tabs as Tabs
import SelectList


main : Bibliopola.Program
main =
    fromShelf shelf


shelf : Shelf
shelf =
    emptyShelf "Molecule"
        |> addBook shelfItem
        |> addBook tabs
        |> addBook bookToggle


tabs : Book
tabs =
    let
        view size =
            Tabs.view identity <|
                SelectList.fromLists [] "StoryPanel" <|
                    List.repeat size "StoryPanel"
    in
    intoBook "Tabs" SelectList.selected view
        |> addStory (Story.build "size" String.fromInt <| List.range 0 10)
        |> buildBook
        |> withFrontCover (view 4 |> Element.map SelectList.selected)


shelfItem : Book
shelfItem =
    let
        toString item =
            "#" ++ Shelf.pathString item

        mapMsg _ =
            "Some event happened!"
    in
    intoBook "ShelfItem" mapMsg ShelfItem.view
        |> addStory
            (Story.build "shelf" toString <| Shelf.openAll Dummy.shelf)
        |> buildBook
        |> withFrontCover (ShelfItem.view Dummy.shelf |> Element.map mapMsg)


bookToggle : Book
bookToggle =
    let
        mapMsg _ =
            "Toggled"
    in
    bookWithFrontCover "BookToggle"
        (BookToggle.view Dummy.model.shelf |> Element.map mapMsg)
