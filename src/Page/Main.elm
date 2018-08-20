module Page.Main exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Model.Shelf as Shelf
import Organism.BookPage as BookPage
import Organism.Panel as Panel
import Organism.Shelf as Shelf
import Route exposing (Route(..))
import Types exposing (..)


view : Model s v -> BibliopolaElement s v
view model =
    namedGrid None
        [ padding 5, spacing 5, height <| percent 100 ]
        { columns = [ px 200, fill ]
        , rows =
            [ fill => [ span 1 "Shelf", span 1 "BookPage" ]
            , px 210 => [ spanAll "Panel" ]
            ]
        , cells =
            [ named "Shelf" <|
                el None [ scrollbars ] <|
                    Shelf.view model
            , named "BookPage" <|
                case model.route of
                    BadUrl bad ->
                        text <| "BadUrl : " ++ bad

                    View paths _ ->
                        if List.isEmpty paths && Shelf.hasNoPage model.shelf then
                            text "Start Page"
                        else
                            BookPage.view paths model
            , named "Panel" <|
                el None [ yScrollbar, clipX, height <| percent 100 ] <|
                    Panel.view model
            ]
        }
