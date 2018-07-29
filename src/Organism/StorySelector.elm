module Organism.StorySelector exposing (..)

import Atom.SelectBox as SelectBox
import Atom.Toggle as Toggle
import Bibliopola exposing (..)
import Dummy
import Element exposing (..)
import Element.Attributes exposing (..)
import Model.ViewTree exposing (..)
import Styles exposing (styles)
import Types exposing (..)


view : ViewTree s v -> MyElement s v
view tree =
    column None
        [ spacing 10 ]
        [ Toggle.view
            { name = "Story Mode"
            , onClick = SetViewTree <| toggleStoryMode tree
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
                            \new -> SetViewTree <| setFormStory name new tree
                        }
                        selected
                )
            |> row None [ paddingLeft 10, spacing 10 ]
        ]


storySelector : ViewItem (Styles s) (Variation v)
storySelector =
    createEmptyViewItem "StorySelector"
        |> withDefaultVariation (view Dummy.storyTree)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewItem styles storySelector
