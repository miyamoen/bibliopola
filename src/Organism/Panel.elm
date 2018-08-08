module Organism.Panel exposing (view)

import Color.Pallet as Pallet exposing (Pallet(Blue))
import Element exposing (..)
import Element.Attributes exposing (..)
import Model.ViewTree as ViewTree exposing (currentViewTree)
import Molecule.Tabs as Tabs
import Organism.Logger as Logger
import Organism.StorySelector as StorySelector
import SelectList exposing (SelectList)
import Types exposing (..)


view : Model s v -> MyElement s v
view ({ panel, logs } as model) =
    column None
        [ height fill ]
        [ Tabs.view panel
        , el None
            [ padding 10
            , height fill
            , inlineStyle
                [ "border-radius" => "0px 0px 5px 5px"
                , "border-color" => "rgb(135, 135, 150)"
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

                MsgLoggerPanel ->
                    Logger.view logs

                Types.AuthorPanel ->
                    column None
                        [ spacing 10
                        , inlineStyle
                            [ "font-size" => "18px"
                            , "font-style" => "italic"
                            , "text-decoration" => "underline"
                            , "color" => Pallet.css Blue
                            ]
                        ]
                        [ newTab packageLink <| text "package site"
                        , newTab gitHubLink <| text "GitHub"
                        , newTab twitterLink <| text "author twitter"
                        ]
        ]


gitHubLink : String
gitHubLink =
    "https://github.com/miyamoen/bibliopola"


packageLink : String
packageLink =
    "http://package.elm-lang.org/packages/miyamoen/bibliopola/latest"


twitterLink : String
twitterLink =
    "https://twitter.com/miyamo_madoka"
