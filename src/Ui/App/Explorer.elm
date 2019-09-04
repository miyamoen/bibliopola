module Ui.App.Explorer exposing (view)

import Browser
import Dict
import Element exposing (..)
import Element.Events exposing (onClick)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Types exposing (..)
import Ui.Basic exposing (..)


view : List (Attribute Msg) -> BoundBook -> Element Msg
view attrs book =
    viewHelp attrs <| Zipper.fromTree book


viewHelp : List (Attribute msg) -> Zipper BoundBookItem -> Element msg
viewHelp attrs book =
    let
        current =
            Zipper.current book

        children =
            Zipper.openAll book
    in
    column []
        [ text current.label
        , column [] <| List.map (Tuple.second >> .label >> text) <| Dict.toList current.pages
        , column [] <| List.map (viewHelp []) children
        ]
