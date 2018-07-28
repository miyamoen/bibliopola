module Page.Main exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Model.ViewTree as ViewTree
import Organism.ViewItem as ViewItem
import Organism.ViewTree as ViewTree
import Route exposing (Route(..))
import Types exposing (..)


view : Model s v -> MyElement s v
view model =
    namedGrid None
        [ padding 5, spacing 5 ]
        { columns = [ px 200, fill ]
        , rows =
            [ fill => [ span 1 "ViewTree", span 1 "ViewItem" ] ]
        , cells =
            [ named "ViewTree" <|
                ViewTree.view model
            , named "ViewItem" <|
                case model.route of
                    BadUrl bad ->
                        text <| "BadUrl : " ++ bad

                    View paths queries ->
                        if List.isEmpty paths && ViewTree.isEmpty model.views then
                            text "Home Page"
                        else
                            ViewItem.view paths queries model
            ]
        }
