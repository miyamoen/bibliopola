module Molecule.Tabs exposing (view)

import Atom.Constant exposing (space)
import Atom.Tab as Tab
import Element exposing (..)
import SelectList as SelectList exposing (Position(..), SelectList)


view : (a -> String) -> SelectList a -> Element (SelectList a)
view toString list =
    row [ spacing <| space -1, width fill ] <|
        SelectList.selectedMap
            (\position item ->
                Tab.view
                    { selected = position == Selected
                    , onClick = item
                    }
                <|
                    toString <|
                        SelectList.selected item
            )
            list
