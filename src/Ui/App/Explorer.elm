module Ui.App.Explorer exposing (view)

import Book
import Browser
import Dict
import Element exposing (..)
import Element.Events exposing (onClick)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Types exposing (..)
import Ui.Basic exposing (..)
import Url.Builder


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

        bookPaths =
            Book.getPath "" book
                |> .bookPaths
    in
    column [ spacing 16 ]
        [ text current.label
        , column
            [ spacing 8
            , paddingEach
                { top = 0, right = 0, bottom = 0, left = 16 }
            ]
          <|
            List.map
                (\( _, page ) ->
                    link []
                        { url = Url.Builder.absolute ("pages" :: bookPaths ++ [ page.label ]) []
                        , label = text page.label
                        }
                )
            <|
                Dict.toList current.pages
        , column
            [ spacing 8
            , paddingEach
                { top = 0, right = 0, bottom = 0, left = 16 }
            ]
          <|
            List.map (viewHelp []) children
        ]
