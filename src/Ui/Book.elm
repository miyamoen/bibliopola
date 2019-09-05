module Ui.Book exposing (book)

import Arg
import Bibliopola
import Book
import Element exposing (Element)
import Page
import Random exposing (Generator)
import Random.Char
import Random.Int
import Random.String
import Types exposing (..)
import Ui.Basic.Book
import Ui.Color as Color


main : Bibliopola.Program
main =
    Bibliopola.displayBook Bibliopola.identityConfig book


book : Book (Element String)
book =
    Book.empty "Bibliopola UI"
        |> Book.bindPage colorPage
        |> Book.bindChapter Ui.Basic.Book.book


colorPage : Page (Element msg)
colorPage =
    Page.fold "color" Color.view
