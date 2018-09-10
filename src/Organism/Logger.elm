module Organism.Logger exposing (view)

import Atom.Constant exposing (space)
import Atom.Icon.Ban as Ban
import Atom.Log as Log
import Color
import Element exposing (..)
import Element.Keyed as Keyed
import Types exposing (..)


view : List Log -> Element Msg
view logs =
    row
        [ spacing <| space 1 ]
        [ Ban.view
            { onClick = Just ClearLogs
            , color = Color.black
            , size = 2
            }
        , Keyed.column [ spacing <| space 1, width fill ] <|
            List.map (\log -> ( String.fromInt log.id, Log.view log )) logs
        ]
