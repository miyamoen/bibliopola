module Arg exposing
    ( fromGenerator, fromList, withGenerator, withList
    , step, toArgView
    )

{-|


## public function

@docs fromGenerator, fromList, withGenerator, withList


## internal function

@docs step, toArgView

-}

import List.Extra as List
import Random exposing (Generator)
import Random.Extra as Random
import Types exposing (..)


fromGenerator : String -> ToString a -> Generator a -> Arg a
fromGenerator label toString gen =
    { label = label
    , toString = toString
    , generator = gen
    , list = Nothing
    }


fromList : String -> ToString a -> a -> List a -> Arg a
fromList label toString item list =
    { label = label
    , toString = toString
    , generator = Random.uniform item list
    , list = Just ( item, list )
    }


{-| 入れ替え
-}
withGenerator : Generator a -> Arg a -> Arg a
withGenerator gen arg =
    { arg | generator = gen }


{-| 入れ替え
-}
withList : a -> List a -> Arg a -> Arg a
withList item list arg =
    { arg | list = Just ( item, list ) }


step : Arg a -> PageSeed -> ( a, PageSeed )
step { list, generator } pageSeed =
    let
        ( select, nextSelects ) =
            case pageSeed.selects of
                s :: ss ->
                    ( s, ss )

                [] ->
                    ( defaultSelect, [] )

        ( randomValue, nextSeed ) =
            Random.step generator pageSeed.seed
    in
    ( case ( list, select.type_, select.index ) of
        ( Just ( item, listItem ), ListArgSelect, Just index ) ->
            if index == 0 then
                item

            else
                List.getAt (index - 1) listItem
                    |> Maybe.withDefault randomValue

        _ ->
            randomValue
    , { seed = nextSeed, selects = nextSelects }
    )


defaultSelect : ArgSelect
defaultSelect =
    { type_ = RandomArgSelect, index = Nothing }


toArgView : Arg a -> a -> ArgView
toArgView arg value =
    { type_ = toViewType arg
    , label = arg.label
    , value = arg.toString value
    }


toViewType : Arg a -> ArgViewType
toViewType { list, toString } =
    case list of
        Nothing ->
            RandomArgView

        Just ( item, listItem ) ->
            ListArgView (toString item) <| List.map toString listItem
