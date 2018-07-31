module Page.Main exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Model.ViewTree as ViewTree exposing (currentViewTree)
import Organism.StorySelector as StorySelector
import Organism.ViewItem as ViewItem
import Organism.ViewTree as ViewTree
import Route exposing (Route(..))
import Types exposing (..)


view : Model s v -> MyElement s v
view model =
    namedGrid None
        [ padding 5, spacing 5, height <| percent 100 ]
        { columns = [ px 200, fill ]
        , rows =
            [ fill => [ span 1 "ViewTree", span 1 "ViewItem" ]
            , px 200 => [ spanAll "Panel" ]
            ]
        , cells =
            [ named "ViewTree" <|
                el None [ scrollbars ] <|
                    ViewTree.view model
            , named "ViewItem" <|
                case model.route of
                    BadUrl bad ->
                        text <| "BadUrl : " ++ bad

                    View paths queries ->
                        if List.isEmpty paths && ViewTree.isEmpty model.views then
                            text "Start Page"
                        else
                            ViewItem.view paths queries model
            , named "Panel"
                (currentViewTree model
                    |> Maybe.map StorySelector.view
                    |> Maybe.withDefault empty
                )
            ]
        }
