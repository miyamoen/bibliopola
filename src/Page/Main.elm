module Page.Main exposing (view)

import Atom.Constant exposing (space)
import Element exposing (..)
import Element.Font as Font
import Organism.BookPage as BookPage
import Organism.Panel as Panel
import Organism.ShelfTree as ShelfTree
import Types exposing (..)


view : SubModel a -> Element Msg
view model =
    column
        [ width fill
        , height fill
        , padding <| space 1
        , spacing <| space 1
        , Font.family
            [ Font.external
                { url = "https://fonts.googleapis.com/css?family=Expletus+Sans"
                , name = "Expletus Sans"
                }
            ]
        ]
        [ row [ height fill ]
            [ el [ scrollbars, width <| px 200, height fill ] <|
                ShelfTree.view model.shelf
            , el [ scrollbars, width fill, height fill ] <|
                BookPage.view model.shelf
            ]
        , el [ scrollbarY, clipX, height <| px 210, width fill ] <|
            Panel.view model
        ]
