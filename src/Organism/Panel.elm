module Organism.Panel exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Model.ViewTree as ViewTree exposing (currentViewTree)
import Molecule.Tabs as Tabs
import Organism.StorySelector as StorySelector
import SelectList exposing (SelectList)
import Types exposing (..)


view : Model s v -> MyElement s v
view ({ panel } as model) =
    column None
        []
        [ Tabs.view panel
        , el None
            [ padding 10
            , height fill
            , inlineStyle
                [ "border-radius" => "0px 0px 5px 5px"
                , "border-color" => "rgba(138, 142, 180, 0.22)"
                , "border-width" => "0px 2px 2px 2px"
                , "background-color" => "rgb(240, 240, 240)"
                ]
            ]
          <|
            case SelectList.selected panel of
                StoryPanel ->
                    currentViewTree model
                        |> Maybe.map StorySelector.view
                        |> Maybe.withDefault empty
        ]
