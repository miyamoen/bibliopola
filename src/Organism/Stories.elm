module Organism.Stories exposing (view)

import Atom.Constant exposing (space, zero)
import Atom.SelectBox as SelectBox
import Element exposing (..)
import Element.Keyed as Keyed
import Model.Book as Book
import Model.Shelf as Shelf
import Molecule.BookToggle as BookToggle
import SelectList exposing (SelectList)
import Types exposing (..)


view : Shelf -> Element Msg
view shelf =
    row
        [ spacing <| space 3, width fill, height fill ]
        [ BookToggle.view shelf
        , Keyed.el [ width fill ] <|
            ( Shelf.pathString shelf
            , wrappedRow
                [ paddingEach { zero | left = space 3 }
                , spacing <| space 3
                , width fill
                ]
                (Shelf.mapBook Book.stories shelf
                    |> SelectList.mapBy_ (selectBoxEl shelf)
                )
            )
        ]


selectBoxEl : Shelf -> SelectList ( String, SelectList String ) -> Element Msg
selectBoxEl shelf focusedStory =
    let
        ( label, selectedOption ) =
            SelectList.selected focusedStory
    in
    SelectBox.view
        { label = label
        , onChange =
            \newOption ->
                SetShelf <|
                    Shelf.updateBook
                        (Book.setStories <|
                            SelectList.toList <|
                                SelectList.set ( label, newOption ) focusedStory
                        )
                        shelf
        , disabled = not <| Shelf.mapBook Book.isOpen shelf
        }
        selectedOption
