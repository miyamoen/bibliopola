module Atom.Icon.Index exposing (shelf)

import Atom.Icon as Icon
import Atom.Icon.Ban as Ban
import Atom.Icon.Book as Book
import Atom.Icon.Books as Books
import Atom.Icon.Caret as Caret exposing (directionToString)
import Atom.Icon.RuledLine as RuledLine exposing (RuledLine(..), ruledLines)
import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Color
import Element exposing (Color, Element)


main : Bibliopola.Program
main =
    fromShelf shelf


shelf : Shelf
shelf =
    emptyShelf "Icon"
        |> addBook caret
        |> addBook ban
        |> addBook book
        |> addBook books
        |> addBook ruledLine


caret : Book
caret =
    let
        view dir color size onClick =
            Caret.view { color = color, size = size, onClick = onClick } dir

        clickStory_ =
            Story "clickEvent"
                [ Tuple.pair "on" <| Just (\dir -> directionToString dir ++ " clicked")
                , Tuple.pair "off" Nothing
                ]

        config =
            { size = 5
            , color = Color.grey
            , onClick = Just (\dir -> directionToString dir ++ " clicked")
            }
    in
    intoBook "Caret" identity view
        |> addStory (Story "direction" Caret.directions)
        |> addStory colorStory
        |> addStory sizeStory
        |> addStory clickStory_
        |> buildBook
        |> withFrontCover (Caret.view config Caret.Up)


viewHelper : (Icon.Config {} msg -> Element msg) -> Color -> Int -> Maybe msg -> Element msg
viewHelper view color size onClick =
    view { color = color, size = size, onClick = onClick }


defaultConfig : Icon.Config {} String
defaultConfig =
    { color = Color.grey
    , onClick = Just "clicked"
    , size = 5
    }


colorStory : Story Color
colorStory =
    Story "fill" Color.colors


clickStory : Story (Maybe String)
clickStory =
    Story "clickEvent"
        [ Tuple.pair "on" <| Just "clicked"
        , Tuple.pair "off" Nothing
        ]


sizeStory : Story Int
sizeStory =
    Story.build String.fromInt "size" <|
        List.range -5 10


ban : Book
ban =
    intoBook "Ban" identity (viewHelper Ban.view)
        |> addStory colorStory
        |> addStory sizeStory
        |> addStory clickStory
        |> buildBook
        |> withFrontCover (Ban.view defaultConfig)


book : Book
book =
    intoBook "Book" identity (viewHelper Book.view)
        |> addStory colorStory
        |> addStory sizeStory
        |> addStory clickStory
        |> buildBook
        |> withFrontCover (Book.view defaultConfig)


books : Book
books =
    intoBook "Books" identity (viewHelper Books.view)
        |> addStory colorStory
        |> addStory sizeStory
        |> addStory clickStory
        |> buildBook
        |> withFrontCover (Books.view defaultConfig)


ruledLine : Book
ruledLine =
    let
        view size ruled =
            RuledLine.view { size = size } ruled
    in
    intoBook "RuledLine" identity view
        |> addStory sizeStory
        |> addStory (Story "RuledLine" ruledLines)
        |> buildBook
        |> withFrontCover (RuledLine.view defaultConfig Vertical)
