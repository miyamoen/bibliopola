module Organism.FrontCover exposing (view)

import Atom.Constant exposing (fontSize, space)
import Atom.Icon.Book as Icon
import Color
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Font as Font
import Model.Book as Book
import Model.Shelf as Shelf
import Types exposing (..)


view : Shelf -> Element Msg
view shelf =
    column
        [ centerX
        , centerY
        , spacing <| space 1
        , onClick <| SetShelf <| Shelf.updateBook Book.toggle shelf
        ]
        [ Icon.view { color = Color.grey, onClick = Nothing, size = 5 }
        , el [ Font.size <| fontSize 2, centerX ] <| text "Click to Open"
        ]
