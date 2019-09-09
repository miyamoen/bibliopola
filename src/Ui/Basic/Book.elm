module Ui.Basic.Book exposing (book)

import Arg
import Bibliopola
import Book
import Color exposing (Color)
import Element exposing (Element)
import Page
import Random exposing (Generator)
import Random.Char
import Random.Int
import Random.String
import Types exposing (..)
import Ui.Basic.Button as Button
import Ui.Basic.Radio as Radio
import Ui.Color as Color


main : Bibliopola.Program
main =
    Bibliopola.displayBook Bibliopola.identityConfig book


book : Book (Element String)
book =
    Book.empty "Basic"
        |> Book.bindPage buttonPage
        |> Book.bindPage radioPage


buttonPage : Page (Element String)
buttonPage =
    Page.fold3 "Button"
        (\color label disabled ->
            Button.view []
                { color = color
                , disabled = disabled
                , label = Element.text label
                , msg = "Clicked"
                }
        )
        (colorArg "color")
        (stringArg "label"
            [ "test label"
            , "longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong"
            ]
        )
        (boolArg "disabled")


radioPage : Page (Element String)
radioPage =
    Page.fold2 "Radio"
        (\selected label -> Radio.view [] { selected = selected, label = label, msg = "Selected" })
        (boolArg "selected")
        (stringArg "label" [ "test label" ])


boolArg : String -> Arg Bool
boolArg label =
    Arg.fromList label
        (\bool ->
            if bool then
                "True"

            else
                "False"
        )
        True
        [ False ]


topRoute : Types.Route
topRoute =
    Types.TopRoute


stringArg : String -> List String -> Arg String
stringArg label values =
    Arg.fromList label identity "" values
        |> Arg.withGenerator (randomLengthStringGenerator Random.Char.latin)


randomLengthStringGenerator : Generator Char -> Generator String
randomLengthStringGenerator genChar =
    Random.andThen (\length -> Random.String.string length genChar) <| Random.int 1 100


colorArg : String -> Arg Color
colorArg label =
    Arg.fromList label
        Color.toString
        (Tuple.first Color.colors)
        (Tuple.second Color.colors)
