module Molecule.Index exposing (..)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Dummy
import Model.Shelf as Shelf
import Molecule.ShelfLine as ShelfLine
import Molecule.Tabs as Tabs
import SelectList exposing (SelectList)
import Styles exposing (styles)
import Types exposing ((=>), PanelItem(StoryPanel), Styles, Variation)


shelf : Shelf (Styles s) (Variation v)
shelf =
    shelfWithoutBook "Molecule"
        |> addBook shelfLine
        |> addBook tabs


tabs : Book (Styles s) (Variation v)
tabs =
    let
        view size =
            Tabs.view <|
                SelectList.fromLists [] StoryPanel <|
                    List.repeat size StoryPanel
    in
    bookWith "Tabs"
        view
        (Story.fromList "size" <| List.range 0 10)
        |> withFrontCover (view 4)


shelfLine : Book (Styles s) (Variation v)
shelfLine =
    let
        toString shelf =
            "#" ++ Shelf.pathString shelf
    in
    bookWith "ShelfLine"
        ShelfLine.view
        (Story.fromListWith toString "shelf" <|
            Shelf.openAllShelves Dummy.shelf
        )
        |> withFrontCover (ShelfLine.view Dummy.shelf)


main : Bibliopola.Program (Styles s) (Variation v)
main =
    fromShelf styles shelf
