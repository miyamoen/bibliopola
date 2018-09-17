module Shelf exposing (shelf)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Hello
import HelloYou
import Html exposing (Html, div, span, text)
import ViewInt


shelf : Shelf
shelf =
    emptyShelf "Shelf"
        |> addBook Hello.book
        |> addBook HelloYou.book
        |> addBook ViewInt.book


main : Bibliopola.Program
main =
    fromShelf shelf
