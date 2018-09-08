module Dummy exposing (model, shelf, storyShelf)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Dict
import Element exposing (column, text)
import Model.Book as Book
import Model.Shelf as Shelf
import Route
import SelectList
import Types exposing (..)


model : SubModel {}
model =
    { shelf = shelf
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


shelf : Types.Shelf
shelf =
    emptyShelf "root"
        |> Shelf.updateBook Book.toggleShelf
        |> addBook (Book.empty "ham" |> Book.toggle)
        |> addShelf
            (emptyShelf "egg"
                |> addBook
                    (Book.empty "boiled"
                        |> withFrontCover (text "boiled")
                    )
                |> addBook
                    (Book.empty "fried"
                        |> withFrontCover (text "fried")
                    )
                |> addBook
                    (Book.empty "scrambled"
                        |> withFrontCover (text "scrambled")
                    )
            )
        |> addShelf
            (shelfWith
                (Book.empty "spam"
                    |> withFrontCover (text "spam")
                    |> Book.toggle
                )
                |> addShelf
                    (shelfWith
                        (Book.empty "spamspam"
                            |> withFrontCover (text "spamspam")
                            |> Book.toggle
                        )
                        |> addBook (Book.empty "spamspamspam")
                    )
            )


storyShelf : Types.Shelf
storyShelf =
    intoBook "4Stories" identity (\a b c d -> text <| String.join ", " [ a, b, c, d ])
        |> addStory
            (Story.build identity
                "aStory"
                [ "aStory1", "aStory2", "aStory3", "aStory4", "aStory5" ]
            )
        |> addStory
            (Story.build identity
                "bStory"
                [ "bStory1", "bStory2", "bStory3", "bStory4", "bStory5" ]
            )
        |> addStory
            (Story.build identity
                "cStory"
                [ "cStory1", "cStory2", "cStory3", "cStory4", "cStory5" ]
            )
        |> addStory
            (Story.build identity
                "dStory"
                [ "dStory1", "dStory2", "dStory3", "dStory4", "dStory5" ]
            )
        |> buildBook
        |> shelfWith
