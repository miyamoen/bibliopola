module Ui.Page.Page exposing (view)

import Book
import Browser
import Element exposing (..)
import Types exposing (..)
import Ui.App.BoundPage as BoundPage
import Ui.Basic exposing (..)


view : PagePath -> BoundBook -> Model -> Element Msg
view path book model =
    Book.find path.bookPaths book
        |> Maybe.andThen (Book.findPage path.pagePath)
        |> Maybe.map (BoundPage.view [ alignTop, width fill, height fill ])
        |> Maybe.withDefault (text "page not found")
