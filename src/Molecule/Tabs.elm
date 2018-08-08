module Molecule.Tabs exposing (..)

import Atom.Tab as Tab
import Element exposing (..)
import Element.Attributes exposing (..)
import SelectList as SelectList exposing (Position(..), SelectList)
import Types exposing (..)


view : Panel -> MyElement s v
view panel =
    row None [ spacing 3, spread ] <|
        SelectList.mapBy
            (\position item ->
                Tab.view
                    { selected = position == Selected
                    , onClick = SetPanel item
                    }
                <|
                    case SelectList.selected item of
                        StoryPanel ->
                            "Story Mode"

                        MsgLoggerPanel ->
                            "Msg Logger"
            )
            panel
