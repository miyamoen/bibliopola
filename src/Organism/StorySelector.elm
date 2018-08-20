module Organism.StorySelector exposing (view)

import Atom.SelectBox as SelectBox
import Atom.Toggle as Toggle
import Element exposing (..)
import Element.Attributes exposing (..)
import Model.Shelf as Shelf
import SelectList
import Types exposing (..)


view : Shelf s v -> BibliopolaElement s v
view shelf =
    row None
        [ spacing 10 ]
        [ Toggle.view
            { name = "Story Mode"
            , onClick = SetShelfWithRoute <| Shelf.toggleStoryMode shelf
            }
          <|
            Shelf.isStoryMode shelf
        , Shelf.stories shelf
            |> SelectList.mapBy_
                (\pos options ->
                    let
                        ( label, list ) =
                            SelectList.selected options
                    in
                    SelectBox.view
                        { label = label
                        , onChange =
                            \new ->
                                SetShelfWithRoute <|
                                    Shelf.setStories
                                        (SelectList.toList <|
                                            SelectList.set ( label, new ) options
                                        )
                                        shelf
                        , disabled = not <| Shelf.isStoryMode shelf
                        }
                        list
                )
            |> wrappedRow None [ paddingLeft 10, spacing 10 ]
        ]
