module Molecule.ItemTree exposing (..)

import Bibliopola exposing (..)
import Dummy
import Element exposing (..)
import Types exposing (..)


view : Model child childVar -> MyElement child childVar
view { views } =
    text <| toString views


viewItem : View (Styles s) (Variation v)
viewItem =
    createViewItem "ItemTree" view [ "default" => Dummy.model ]


main : Program Never (Model (Styles s) (Variation v)) Msg
main =
    createMainFromViewItem [] viewItem
