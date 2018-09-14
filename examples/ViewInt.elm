module ViewInt exposing (book, view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Html exposing (Html, div, span, text)


view : Int -> Html msg
view num =
    div []
        [ span [] [ text "ViewInt.view : " ]
        , span [] [ text <| String.fromInt num ]
        ]


book : Book
book =
    intoBook "ViewInt" identity view
        |> addStory (Story.build "int" String.fromInt [ -5, 0, 1, 4, 5, 10 ])
        |> buildHtmlBook


main : Bibliopola.Program
main =
    fromBook book
