module Page.Index exposing (shelf)

import Bibliopola exposing (..)
import Dummy
import Element
import Page.Main as Main


main : Bibliopola.Program
main =
    fromShelf shelf


shelf : Shelf
shelf =
    emptyShelf "Page"
        |> addBook mainPage


mainPage : Book
mainPage =
    bookWithFrontCover "Main" <|
        Element.map (\_ -> "Some event happened.") <|
            Main.view Dummy.model
