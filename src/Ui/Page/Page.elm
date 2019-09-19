module Ui.Page.Page exposing (view)

import Book
import Browser
import Element exposing (..)
import Types exposing (..)
import Ui.App.Main as Main
import Ui.Basic exposing (..)


view : List (Attribute PageMsg) -> PagePath -> BoundBook -> Model -> Element Msg
view attrs path book model =
    Book.find path.bookPaths book
        |> Maybe.andThen (Book.findPage path.pagePath)
        |> Maybe.map (Main.view (height fill :: attrs) >> map (PageMsg path))
        |> Maybe.withDefault (text "page not found")
