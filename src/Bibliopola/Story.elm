module Bibliopola.Story exposing
    ( build, addOption, map
    , bool
    )

{-| This sub pacckage help to build `Story`.

@docs build, addOption, map


## Helper

@docs bool

-}

import Bibliopola exposing (Story)


{-| Build `Story`.

    |> addStory (Story.build "name" identity [ "spam", "egg", "ham" ])

First argument is label of story.
Second is `toString` function that make label of option.
Last is options of argument of `view`.

To build `Story`, use this or `Story` constructor directly.

-}
build : String -> (a -> String) -> List a -> Story a
build storyLabel toOptionLabel options =
    { label = storyLabel
    , options = List.map (\option -> ( toOptionLabel option, option )) options
    }


{-| Add new option to a story.

Add head of options.

    |> addStory
        (Story "label" labels
            |> Story.map Just
            |> Story.addOption "nothing" Nothing
        )

-}
addOption : String -> a -> Story a -> Story a
addOption optionLabel a story =
    { story | options = ( optionLabel, a ) :: story.options }


{-| Transform `Story a` to `Story b`.
-}
map : (a -> b) -> Story a -> Story b
map tagger { label, options } =
    { label = label
    , options = List.map (Tuple.mapSecond tagger) options
    }


{-|

    bool label =
        { label = label
        , options = [ ( "true", True ), ( "false", False ) ]
        }

-}
bool : String -> Story Bool
bool label =
    { label = label
    , options = [ Tuple.pair "true" True, Tuple.pair "false" False ]
    }
