module Book exposing (bindHtml, fold, fold1)

import Arg
import Element exposing (Element)
import Html exposing (Html)
import List.Extra as List
import Random exposing (Generator)
import Types exposing (..)


htmlStitcher : (msg -> String) -> Stitcher (Html msg)
htmlStitcher msgToString =
    \html -> HtmlPage <| Html.map (msgToString >> LogMsg) html


elementStitcher : (msg -> String) -> Stitcher (Element msg)
elementStitcher msgToString =
    \element -> ElementPage <| Element.map (msgToString >> LogMsg) element



-- mapHtml : Html msg ->


fold : view -> UnboundBook view
fold view =
    { book = \{ seed, selects } -> ( view, [] )
    , args = []
    }


fold1 : (a -> view) -> Arg a -> UnboundBook view
fold1 view argA =
    { book =
        \bookArg ->
            let
                ( a, bookArgA ) =
                    Arg.consumeBookArg bookArg argA.type_
            in
            ( view a, [ argA.toString a ] )
    , args = [ Arg.toView argA ]
    }


fold2 : (a -> b -> view) -> Arg a -> Arg b -> UnboundBook view
fold2 view argA argB =
    { book =
        \bookArg ->
            let
                ( a, bookArgA ) =
                    Arg.consumeBookArg bookArg argA.type_

                ( b, bookArgB ) =
                    Arg.consumeBookArg bookArgA argB.type_
            in
            ( view a b, [ argA.toString a, argB.toString b ] )
    , args = [ Arg.toView argA, Arg.toView argB ]
    }


bindHtml : UnboundBook (Html PageMsg) -> Book
bindHtml unbound =
    -- \arg -> HtmlPage <| unbound arg
    Debug.todo "String.String"



-- bind : (a -> view) -> Arg a ->
