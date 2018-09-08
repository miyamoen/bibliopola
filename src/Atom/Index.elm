module Atom.Index exposing (shelf)

-- import Atom.SelectBox as SelectBox

import Atom.Icon.Index as Icon
import Atom.Log as Log
import Atom.Tab as Tab
import Atom.Toggle as Toggle
import Bibliopola exposing (..)
import Bibliopola.Story as Story


main : Bibliopola.Program
main =
    fromShelf shelf


shelf : Shelf
shelf =
    emptyShelf "Atom"
        |> addShelf Icon.shelf
        |> addShelf
            (emptyShelf "Form"
                |> addBook toggle
            )
        |> addBook tab
        |> addBook log


toggle : Book
toggle =
    let
        msg on =
            if on then
                "Clicked off"

            else
                "Clicked on"

        view label on =
            Toggle.view { label = label, onClick = msg } on
    in
    intoBook "Toggle" identity view
        |> addStory (Story "label" labels)
        |> addStory (Story.bool "on")
        |> buildBook
        |> withFrontCover (view "On" True)


tab : Book
tab =
    let
        view label selected =
            Tab.view { selected = selected, onClick = "clicked" } label
    in
    intoBook "Tab" identity view
        |> addStory (Story "label" labels)
        |> addStory (Story.bool "selected")
        |> buildBook
        |> withFrontCover (view "Tab Label" True)


log : Book
log =
    let
        view id message =
            Log.view { id = id, message = message }
    in
    intoBook "Log" identity view
        |> addStory (Story.build String.fromInt "id" [ 1, 99, 999, 9999 ])
        |> addStory (Story "message" labels)
        |> buildBook
        |> withFrontCover (view 0 "dummy message")


labels : List ( String, String )
labels =
    [ Tuple.pair "empty" ""
    , Tuple.pair "one" "a"
    , Tuple.pair "short" "ham egg"
    , Tuple.pair "middle" "ham egg spam spam"
    , Tuple.pair "long" "HogehogehogehogeHogehogehogehogeHogehogehogehogeHoge"
    , Tuple.pair "lines" """HogehogehogehogeHogehogehogehogeHogehogehogehogeHoge
HogehogehogehogeHogehogehogehogeHogehogehogehogeHoge
HogehogehogehogeHogehogehogehogeHogehogehogehogeHoge
HogehogehogehogeHogehogehogehogeHogehogehogehogeHoge"""
    ]
