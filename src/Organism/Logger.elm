module Organism.Logger exposing (..)

import Atom.Ban as Ban
import Atom.LogLine as LogLine
import Color.Pallet as Pallet exposing (Pallet(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Keyed as Keyed
import Types exposing (..)


view : List Log -> MyElement s v
view logs =
    row None
        [ spacing 5 ]
        [ Ban.view
            { onClick = Just ClearLogs
            , pallet = Black
            , size = 20
            }
        , Keyed.column None [ spacing 5, width fill ] <|
            List.map (\log -> toString log.id => LogLine.view log) logs
        ]
