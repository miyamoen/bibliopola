module Ui.App.Explorer exposing (view)

import Book
import Browser
import Color.Manipulate as Color
import Dict exposing (Dict)
import Element exposing (..)
import Element.Background as Background
import Element.Events exposing (onClick)
import Element.Font as Font
import FeatherIcons
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Types exposing (..)
import Ui.Basic exposing (..)
import Ui.Color as Color
import Url.Builder


view : List (Attribute Msg) -> Route -> BoundBook -> Element Msg
view attrs route book =
    let
        zipper =
            Zipper.fromTree book

        root =
            Zipper.current zipper
    in
    column ([ spacing 8, Font.size 16 ] ++ attrs)
        [ row
            [ width fill
            , paddingXY 8 8
            , spacing 8
            , Background.color <| Color.uiColor <| Color.fadeOut 0.8 Color.white
            ]
            [ text root.label
            , icon [ alignRight, onClick OpenAllBook, pointer ] 16 FeatherIcons.bookOpen
            , icon [ onClick CloaseAllBook, pointer ] 16 FeatherIcons.book
            ]
        , column
            [ width fill
            , paddingEach
                { top = 0, right = 0, bottom = 0, left = 16 }
            ]
            [ pageLabels [] root.pages
            , chapterLabels <| Zipper.openAll zipper
            ]
        ]


viewHelp : Zipper BoundBookItem -> Element Msg
viewHelp book =
    let
        current =
            Zipper.current book

        bookPaths =
            Book.getPath "" book
                |> .bookPaths
    in
    column [ width fill ]
        [ chapterLabel bookPaths current
        , if current.open then
            column
                [ width fill
                , paddingEach
                    { top = 0, right = 0, bottom = 0, left = 32 }
                ]
                [ pageLabels bookPaths current.pages
                , chapterLabels <| Zipper.openAll book
                ]

          else
            none
        ]


chapterLabels : List (Zipper BoundBookItem) -> Element Msg
chapterLabels chapters =
    column [ width fill ] <|
        List.map viewHelp chapters


chapterLabel : List String -> BoundBookItem -> Element Msg
chapterLabel paths chapter =
    row
        [ width fill
        , spacing 8
        , paddingEach { top = 12, right = 0, bottom = 8, left = 0 }
        , mouseOver [ Background.color <| Color.uiColor <| Color.fadeOut 0.9 Color.white ]
        , pointer
        , onClick <|
            if chapter.open then
                CloseBook paths

            else
                OpenBook paths
        ]
        [ icon [] 16 <|
            if chapter.open then
                FeatherIcons.folderMinus

            else
                FeatherIcons.folderPlus
        , text chapter.label
        ]


pageLabels : List String -> Dict String BoundPage -> Element msg
pageLabels bookPaths pages =
    column [ width fill ] <|
        List.map (pageLabel bookPaths) <|
            Dict.toList pages


pageLabel : List String -> ( String, BoundPage ) -> Element msg
pageLabel bookPaths ( pagePath, page ) =
    link
        [ width fill
        , paddingEach { top = 8, right = 0, bottom = 4, left = 0 }
        , mouseOver [ Background.color <| Color.uiColor <| Color.fadeOut 0.9 Color.white ]
        ]
        { url = Url.Builder.absolute ("pages" :: bookPaths ++ [ pagePath ]) []
        , label =
            row [ spacing 8 ]
                [ icon [] 16 FeatherIcons.file
                , text pagePath
                ]
        }


icon : List (Attribute msg) -> Float -> FeatherIcons.Icon -> Element msg
icon attrs size icon_ =
    icon_
        |> FeatherIcons.withSize size
        |> FeatherIcons.toHtml []
        |> html
        |> el ([ Font.color <| Color.uiColor Color.font ] ++ attrs)
