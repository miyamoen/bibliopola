module Organism.Index exposing (..)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Dummy
import Model.Shelf exposing (toggleStoryMode)
import Organism.BookPage as BookPage
import Organism.Logger as Logger
import Organism.Panel as Panel
import Organism.Shelf as Shelf
import Organism.StorySelector as StorySelector
import SelectList exposing (Direction(After))
import Styles exposing (styles)
import Types exposing ((=>), Styles, Variation)


shelf : Shelf (Styles s) (Variation v)
shelf =
    shelfWithoutBook "Organism"
        |> addBook bookPage
        |> addBook shelfBook
        |> addBook panel
        |> addBook storySelector
        |> addBook logger


bookPage : Book (Styles s) (Variation v)
bookPage =
    bookWith "BookPage"
        (\path -> BookPage.view path Dummy.model)
        (Story "path" [ "empty" => [] ])
        |> withFrontCover (BookPage.view [] Dummy.model)


shelfBook : Book (Styles s) (Variation v)
shelfBook =
    bookWithoutStory "Shelf"
        |> withFrontCover (Shelf.view Dummy.model)


storySelector : Book (Styles s) (Variation v)
storySelector =
    bookWith "StorySelector"
        (\on ->
            if on then
                StorySelector.view <| toggleStoryMode Dummy.storyShelf
            else
                StorySelector.view Dummy.storyShelf
        )
        (Story.bool "on")
        |> withFrontCover (StorySelector.view Dummy.storyShelf)


panel : Book (Styles s) (Variation v)
panel =
    let
        model =
            Dummy.model

        panel =
            .panel Dummy.model

        view index =
            { model
                | panel =
                    SelectList.attempt (SelectList.steps After index) panel
            }
                |> Panel.view
    in
    bookWith "Panel"
        view
        (Story.fromList "index" <| List.range 0 5)
        |> withFrontCover (Panel.view Dummy.model)


logger : Book (Styles s) (Variation v)
logger =
    let
        logs =
            List.range 0 100
                |> List.map (\id -> { id = id, message = "dummy message" })
    in
    bookWith "Logger"
        Logger.view
        (Story.fromList "size" [ 0, 1, 5, 10, 20, 100 ]
            |> Story.map (\size -> List.reverse <| List.take size logs)
        )
        |> withFrontCover (Logger.view <| .logs Dummy.model)


main : Bibliopola.Program (Styles s) (Variation v)
main =
    fromShelf styles shelf
