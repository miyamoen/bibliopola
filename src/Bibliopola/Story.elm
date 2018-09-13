module Bibliopola.Story exposing
    ( build, addOption, map
    , bool
    )

{-|

@docs build, addOption, map

@docs bool

-}

import Bibliopola exposing (Story)


{-| -}
build : String -> (a -> String) -> List a -> Story a
build storyLabel toOptionLabel options =
    { label = storyLabel
    , options = List.map (\option -> ( toOptionLabel option, option )) options
    }


{-| -}
addOption : String -> a -> Story a -> Story a
addOption optionLabel a story =
    { story | options = ( optionLabel, a ) :: story.options }


{-| -}
map : (a -> b) -> Story a -> Story b
map tagger { label, options } =
    { label = label
    , options = List.map (Tuple.mapSecond tagger) options
    }


{-| -}
bool : String -> Story Bool
bool label =
    { label = label
    , options = [ Tuple.pair "true" True, Tuple.pair "false" False ]
    }
