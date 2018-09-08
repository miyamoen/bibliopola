module Page.Main exposing (view)

-- import Organism.Panel as Panel

import Atom.Constant exposing (..)
import Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Model.Shelf as Shelf
import Organism.BookPage as BookPage
import Organism.ShelfTree as ShelfTree
import Types exposing (..)


view : SubModel a -> Element Msg
view model =
    column
        [ padding <| space 1, spacing <| space 1 ]
        [ row [ height <| px 400 ]
            [ el [ scrollbars, width <| px 200 ] <|
                ShelfTree.view model.shelf
            , BookPage.view model.shelf
            ]
        , el [ scrollbarY, clipX, height <| px 210 ] <|
            -- Panel.view model
            text "Panel Todo"
        ]
