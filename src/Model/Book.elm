module Model.Book
    exposing
        ( hasNoStory
        , isOptionMode
        , name
        , options
        , selectedOptions
        , setOptions
        , state
        , stories
        , toggle
        , toggleOptionMode
        )

import Dict exposing (Dict)
import SelectList exposing (SelectList)
import Types exposing (..)


stories : Book s v -> Dict String (LazyElement s v)
stories (Book book) =
    book.stories


options : Book s v -> List ( String, SelectList String )
options (Book book) =
    book.options


selectedOptions : Book s v -> List ( String, String )
selectedOptions book =
    options book
        |> List.map (Tuple.mapSecond SelectList.selected)


state : Book s v -> State
state (Book book) =
    book.state


name : Book s v -> String
name (Book book) =
    book.name


hasNoStory : Book s v -> Bool
hasNoStory book =
    stories book
        |> Dict.isEmpty


isOptionMode : Book s v -> Bool
isOptionMode (Book book) =
    book.optionModeOn


setOptions : List ( String, SelectList String ) -> Book s v -> Book s v
setOptions options (Book book) =
    Book { book | options = options }


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


toggleOptionMode : Book s v -> Book s v
toggleOptionMode (Book book) =
    Book { book | optionModeOn = not book.optionModeOn }
