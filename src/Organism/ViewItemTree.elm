module Organism.ViewItemTree exposing (..)

import Bibliopola exposing (..)
import Dummy
import Element exposing (..)
import Element.Attributes exposing (..)
import Model.Views as Views
import Molecule.ViewItem as ViewItem
import Styles exposing (styles)
import Types exposing (..)


view : Model child childVar -> MyElement child childVar
view { views } =
    column None [ spacing 5 ] <|
        List.map ViewItem.view <|
            Views.openRecursively views


viewItem : View (Styles s) (Variation v)
viewItem =
    createEmptyViewItem "ViewItemTree"
        |> withDefaultVariation (view Dummy.model)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewItem styles viewItem
