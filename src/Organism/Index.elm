module Organism.Index exposing (shelf)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Dummy
import Element exposing (Element)
import Model.Book as Book
import Model.Shelf as Shelf
import Organism.BookPage as BookPage
import Organism.Credit as Credit
import Organism.FrontCover as FrontCover
import Organism.Logger as Logger
import Organism.Panel as Panel
import Organism.ShelfTree as ShelfTree
import Organism.Stories as Stories
import SelectList


main : Bibliopola.Program
main =
    fromShelf shelf


shelf : Shelf
shelf =
    emptyShelf "Organism"
        |> addBook bookPage
        |> addBook frontCover
        |> addBook shelfTree
        |> addBook panel
        |> addBook stories
        |> addBook logger


bookPage : Book
bookPage =
    bookWithFrontCover "BookPage"
        (BookPage.view Dummy.model.shelf |> mapMsg)


frontCover : Book
frontCover =
    bookWithFrontCover "FrontCover"
        (FrontCover.view Dummy.model.shelf |> mapMsg)


shelfTree : Book
shelfTree =
    bookWithFrontCover "Shelf"
        (ShelfTree.view Dummy.model.shelf |> mapMsg)


stories : Book
stories =
    intoBook "Stories"
        toString
        (\on ->
            if on then
                Shelf.updateBook Book.toggle Dummy.storyShelf
                    |> Stories.view

            else
                Stories.view Dummy.storyShelf
        )
        |> addStory (Story.bool "bookIsOpen")
        |> buildBook
        |> withFrontCover (Stories.view Dummy.storyShelf |> mapMsg)


panel : Book
panel =
    let
        model =
            Dummy.model

        panel_ =
            .panel Dummy.model

        view index =
            { model
                | panel =
                    SelectList.attempt (SelectList.selectBy index) panel_
            }
                |> Panel.view
                |> mapMsg
    in
    intoBook "Panel"
        identity
        view
        |> addStory (Story.build "index" String.fromInt <| List.range 0 5)
        |> buildBook
        |> withFrontCover (Panel.view Dummy.model |> mapMsg)


logger : Book
logger =
    let
        logs =
            List.range 0 100
                |> List.map (\id -> { id = id, message = "dummy message" })
    in
    intoBook "Logger" toString Logger.view
        |> addStory
            (Story.build "size" String.fromInt [ 0, 1, 5, 10, 20, 100 ]
                |> Story.map (\size -> List.reverse <| List.take size logs)
            )
        |> buildBook
        |> withFrontCover (mapMsg <| Logger.view <| .logs Dummy.model)


mapMsg : Element a -> Element String
mapMsg elm =
    Element.map toString elm


toString : a -> String
toString _ =
    "Some event happened!"
