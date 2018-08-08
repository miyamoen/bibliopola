module Organism.StorySelector exposing (view)

import Atom.SelectBox as SelectBox
import Atom.Toggle as Toggle
import Element exposing (..)
import Element.Attributes exposing (..)
import Model.ViewTree exposing (..)
import Types exposing (..)


view : ViewTree s v -> MyElement s v
view tree =
    row None
        [ spacing 10 ]
        [ Toggle.view
            { name = "Story Mode"
            , onClick = SetViewTreeWithRoute <| toggleStoryMode tree
            }
          <|
            isStoryMode tree
        , getFormStories tree
            |> List.map
                (\{ name, selected, options } ->
                    SelectBox.view
                        { name = name
                        , options = options
                        , onChange =
                            \new -> SetViewTreeWithRoute <| setFormStory name new tree
                        , disabled = not <| isStoryMode tree
                        }
                        selected
                )
            |> wrappedRow None [ paddingLeft 10, spacing 10 ]
        ]
