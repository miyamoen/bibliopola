module Hello exposing (book, view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (Element, text)


view : Element msg
view =
    text "Hello, Bibliopola"


book : Book
book =
    bookWithFrontCover "Hello" view


main : Bibliopola.Program
main =
    fromBook book
