module Model.Book
    exposing
        ( currentPage
        , frontCover
        , hasNoPage
        , isStoryMode
        , name
        , pages
        , selectedStory
        , setStories
        , state
        , stories
        , toggle
        , toggleStoryMode
        )

import Dict exposing (Dict)
import SelectList exposing (SelectList)
import Types exposing (..)


-- Query


pages : Book s v -> Dict String (LazyElement s v)
pages (Book book) =
    book.pages


stories : Book s v -> List ( String, SelectList String )
stories (Book book) =
    book.stories


selectedStory : Book s v -> List ( String, String )
selectedStory book =
    stories book
        |> List.map (Tuple.mapSecond SelectList.selected)


state : Book s v -> State
state (Book book) =
    book.state


name : Book s v -> String
name (Book book) =
    book.name


hasNoPage : Book s v -> Bool
hasNoPage book =
    pages book
        |> Dict.isEmpty


isStoryMode : Book s v -> Bool
isStoryMode (Book book) =
    book.storyModeOn


frontCover : Book s v -> Maybe (LazyElement s v)
frontCover book =
    Dict.get "frontCover" (pages book)


currentPage : Book s v -> Maybe (LazyElement s v)
currentPage book =
    Dict.get
        (selectedStory book
            |> List.map Tuple.second
            |> String.join "/"
        )
        (pages book)



-- Operation


setStories : List ( String, SelectList String ) -> Book s v -> Book s v
setStories stories (Book book) =
    Book { book | stories = stories }


toggle : Book s v -> Book s v
toggle (Book book) =
    Book
        { book
            | state =
                case book.state of
                    Open ->
                        Close

                    Close ->
                        Open
        }


toggleStoryMode : Book s v -> Book s v
toggleStoryMode (Book book) =
    Book { book | storyModeOn = not book.storyModeOn }
