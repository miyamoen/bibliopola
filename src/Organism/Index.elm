module Organism.Index exposing (..)

import Bibliopola exposing (..)
import Dict exposing (Dict)
import Dummy
import Model.ViewTree exposing (toggleStoryMode)
import Organism.StorySelector as StorySelector
import Organism.ViewItem as ViewItem
import Organism.ViewTree as ViewTree
import Styles exposing (styles)
import Types exposing (..)


tree : ViewTree (Styles s) (Variation v)
tree =
    createEmptyViewTree "Organism"
        |> insertViewItem viewItem
        |> insertViewItem viewItemTree
        |> insertViewItem storySelector


viewItem : ViewItem (Styles s) (Variation v)
viewItem =
    createViewItem2 "ViewItem"
        (\path query -> ViewItem.view path query Dummy.model)
        ( "path", [ "empty" => [] ] )
        ( "query", [ "empty" => Dict.empty ] )
        |> withDefaultVariation (ViewItem.view [] Dict.empty Dummy.model)


viewItemTree : ViewItem (Styles s) (Variation v)
viewItemTree =
    createEmptyViewItem "ViewTree"
        |> withDefaultVariation (ViewTree.view Dummy.model)


storySelector : ViewItem (Styles s) (Variation v)
storySelector =
    createViewItem "StorySelector"
        (\on ->
            if on then
                StorySelector.view <| toggleStoryMode Dummy.storyTree
            else
                StorySelector.view Dummy.storyTree
        )
        ( "on", [ "True" => True, "False" => False ] )
        |> withDefaultVariation (StorySelector.view Dummy.storyTree)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewTree styles tree
