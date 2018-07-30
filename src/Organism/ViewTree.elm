module Organism.ViewTree exposing (..)

import Element.Attributes exposing (..)
import Element.Keyed exposing (column)
import Model.ViewTree as ViewTree
import Molecule.ViewTreeLine as ViewItemTreeLine
import Types exposing (..)


view : Model child childVar -> MyElement child childVar
view { views } =
    column None [ spacing 5 ] <|
        List.map line <|
            ViewTree.openRecursively views


line : ViewTree s v -> ( String, MyElement s v )
line tree =
    ViewTree.getPathString tree => ViewItemTreeLine.view tree
