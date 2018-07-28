module Organism.ViewTree exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Model.Views as Views
import Molecule.ViewTreeLine as ViewItemTreeLine
import Types exposing (..)


view : Model child childVar -> MyElement child childVar
view { views } =
    column None [ spacing 5 ] <|
        List.map ViewItemTreeLine.view <|
            Views.openRecursively views
