module Page.Index exposing (..)

import Bibliopola exposing (..)
import Dummy
import Page.Main as Main
import Styles exposing (styles)
import Types exposing ((=>), Styles, Variation)


shelf : Shelf (Styles s) (Variation v)
shelf =
    shelfWithoutBook "Page"
        |> addBook mainPage


mainPage : Book (Styles s) (Variation v)
mainPage =
    bookWithoutStory "Main"
        |> withFrontCover (Main.view Dummy.model)


main : Bibliopola.Program (Styles s) (Variation v)
main =
    fromShelf styles shelf
