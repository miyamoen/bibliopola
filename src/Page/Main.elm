module Page.Main exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Organism.ViewItem as ViewItem
import Organism.ViewTree as ViewItemTree
import Route exposing (Route(..))
import Types exposing (..)


view : Model s v -> MyElement s v
view model =
    namedGrid None
        [ padding 5, spacing 5 ]
        { columns = [ px 200, fill ]
        , rows =
            [ fill => [ span 1 "ViewItemTree", span 1 "ViewItem" ] ]
        , cells =
            [ named "ViewItemTree" <|
                ViewItemTree.view model
            , named "ViewItem" <|
                case model.route of
                    BadUrl bad ->
                        text <| "BadUrl : " ++ bad

                    View paths queries ->
                        ViewItem.view paths queries model
            ]
        }
