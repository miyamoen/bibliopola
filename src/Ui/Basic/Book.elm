module Ui.Basic.Book exposing (boolArg, radioPage)

import Arg
import Bibliopola
import Element exposing (Element)
import Page
import Random exposing (Generator)
import Random.Char
import Random.Int
import Random.String
import Types exposing (..)
import Ui.Basic.Radio as Radio


main : Bibliopola.Program
main =
    Bibliopola.displayPage Bibliopola.identityConfig radioPage


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
