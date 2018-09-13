module Organism.Stories exposing (view)

import Atom.Constant exposing (space, zero)
import Atom.SelectBox as SelectBox
import Atom.Toggle as Toggle
import Element exposing (..)
import Element.Keyed as Keyed
import Model.Book as Book
import Model.Shelf as Shelf
import SelectList exposing (SelectList)
import Types exposing (..)


view : Shelf -> Element Msg
view shelf =
    row
        [ spacing <| space 3 ]
        [ Toggle.view
            { label = "Book Open"
            , onClick = \_ -> SetShelf <| Shelf.updateBook Book.toggle shelf
            }
          <|
            Shelf.mapBook Book.isOpen shelf
        , Keyed.el [] <|
            ( Shelf.pathString shelf
            , wrappedRow
                [ paddingEach { zero | left = space 3 }
                , spacing <| space 3
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
