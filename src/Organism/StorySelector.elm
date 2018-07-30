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
            |> row None [ paddingLeft 10, spacing 10 ]
        ]


storySelector : ViewItem (Styles s) (Variation v)
storySelector =
    createViewItem "StorySelector"
        (\on ->
            if on then
                view <| toggleStoryMode Dummy.storyTree
            else
                view Dummy.storyTree
        )
        ( "on", [ "True" => True, "False" => False ] )
        |> withDefaultVariation (view Dummy.storyTree)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewItem styles storySelector
