module Page.Main exposing (view)

-- import Organism.Panel as Panel
-- import Organism.Shelf as Shelf

import Atom.Constant exposing (..)
import Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Model.Shelf as Shelf
import Organism.BookPage as BookPage
import Types exposing (..)


view : SubModel a -> Element Msg
view model =
    column
        [ padding <| space 1, spacing <| space 1 ]
        [ row []
            [ el [ scrollbars, width <| px 200 ] <|
                --Shelf.view model
                text "Shelf tree todo"
            , BookPage.view model
            ]
        , el [ scrollbarY, clipX, height <| px 210 ] <|
            -- Panel.view model
            text "Panel Todo"
        ]
