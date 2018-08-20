module Bibliopola.Story exposing (bool, fromList, fromListWith, map)

import Bibliopola exposing (Story)


fromList : String -> List a -> Story a
fromList label options =
    fromListWith Basics.toString label options


fromListWith : (a -> String) -> String -> List a -> Story a
fromListWith toString label options =
    { label = label
    , options = List.map (\option -> ( toString option, option )) options
    }


bool : String -> Story Bool
bool label =
    fromList label [ True, False ]


map : (a -> b) -> Story a -> Story b
map tagger { label, options } =
    { label = label
    , options = List.map (Tuple.mapSecond tagger) options
    }
