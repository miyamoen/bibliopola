module Bibliopola.Story
    exposing
        ( addOption
        , bool
        , fromList
        , fromListWith
        , map
        )

import Bibliopola exposing (Story)


fromList : String -> List a -> Story a
fromList label options =
    fromListWith Basics.toString label options


fromListWith : (a -> String) -> String -> List a -> Story a
fromListWith toString label options =
    { label = label
    , options = List.map (\option -> ( toString option, option )) options
    }


addOption : String -> a -> Story a -> Story a
addOption label a story =
    { story | options = ( label, a ) :: story.options }


map : (a -> b) -> Story a -> Story b
map tagger { label, options } =
    { label = label
    , options = List.map (Tuple.mapSecond tagger) options
    }


bool : String -> Story Bool
bool label =
    fromList label [ True, False ]
