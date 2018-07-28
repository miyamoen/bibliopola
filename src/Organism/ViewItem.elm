module Organism.ViewItem exposing (..)

import Dict exposing (Dict)
import Element exposing (..)
import Lazy
import Model.Views as Views
import Types exposing (..)


view :
    List String
    -> Dict String String
    -> Model s v
    -> MyElement s v
view paths queries model =
    model.views
        |> Views.openPath paths
        |> Result.andThen (Views.openStory queries)
        |> Result.map Lazy.force
        |> resultExtract text
        |> Element.mapAll identity Child ChildVar


resultExtract : (e -> a) -> Result e a -> a
resultExtract f x =
    case x of
        Ok a ->
            a

        Err e ->
            f e
