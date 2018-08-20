module Dummy exposing (..)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Dict
import Element exposing (column, text)
import Model.Book as Book
import Model.Shelf as Shelf
import Route
import SelectList
import Types exposing (..)


model : Model s v
model =
    { styles = []
    , shelf = shelf
    , route = Route.View [] Dict.empty
    , panel =
        SelectList.fromLists []
            StoryPanel
            [ MsgLoggerPanel, AuthorPanel, StoryPanel, StoryPanel, StoryPanel ]
    , logs =
        [ { id = 2, message = "dummy msg" }
        , { id = 1, message = "dummy msg" }
        , { id = 0, message = "dummy msg" }
        ]
    }


shelf : Types.Shelf s v
shelf =
    shelfWithoutBook "root"
        |> Shelf.toggleShelf
        |> addBook (bookWithoutStory "ham" |> Book.toggle)
        |> addShelf
            (shelfWithoutBook "egg"
                |> addBook
                    (bookWithoutStory "boiled"
                        |> withFrontCover (text "boiled")
                    )
                |> addBook
                    (bookWithoutStory "fried"
                        |> withFrontCover (text "fried")
                    )
                |> addBook
                    (bookWithoutStory "scrambled"
                        |> withFrontCover (text "scrambled")
                    )
            )
        |> addShelf
            (shelfWith
                (bookWithoutStory "spam"
                    |> withFrontCover (text "spam")
                    |> Book.toggle
                )
                |> addShelf
                    (shelfWith
                        (bookWithoutStory "spamspam"
                            |> withFrontCover (text "spamspam")
                            |> Book.toggle
                        )
                        |> addBook (bookWithoutStory "spamspamspam")
                    )
            )


storyShelf : Types.Shelf s v
storyShelf =
    bookWith4 "4Stories"
        (\a b c d -> text <| String.join ", " [ a, b, c, d ])
        (Story.fromList "aStory"
            [ "aStory1", "aStory2", "aStory3", "aStory4", "aStory5" ]
        )
        (Story.fromList "bStory"
            [ "bStory1", "bStory2", "bStory3", "bStory4", "bStory5" ]
        )
        (Story.fromList "cStory"
            [ "cStory1", "cStory2", "cStory3", "cStory4", "cStory5" ]
        )
        (Story.fromList "dStory"
            [ "dStory1", "dStory2", "dStory3", "dStory4", "dStory5" ]
        )
        |> shelfWith
