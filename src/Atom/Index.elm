module Atom.Index exposing (..)

import Atom.Ban as Ban
import Atom.Caret as Caret
import Atom.File as File
import Atom.Folder as Folder
import Atom.Icon.Book as Book
import Atom.Icon.Books as Books
import Atom.LogLine as LogLine
import Atom.SelectBox as SelectBox
import Atom.Tab as Tab
import Atom.Toggle as Toggle
import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Color.Pallet as Pallet exposing (Pallet(..))
import SelectList
import Styles exposing (styles)
import Types exposing ((=>), Styles, Variation)


shelf : Shelf (Styles s) (Variation v)
shelf =
    shelfWithoutBook "Atom"
        |> addShelf
            (shelfWithoutBook "Icon"
                |> addBook caret
                |> addBook file
                |> addBook folder
                |> addBook ban
                |> addBook book
                |> addBook books
            )
        |> addShelf
            (shelfWithoutBook "Form"
                |> addBook selectBox
                |> addBook toggle
            )
        |> addBook tab
        |> addBook logLine


caret : Book (Styles s) (Variation v)
caret =
    let
        config pallet =
            { pallet = pallet
            , onClick = Just (\dir -> toString dir ++ " clicked!")
            , size = 256
            }
    in
    bookWith2 "Caret"
        Caret.view
        (Story.fromList "pallet" Pallet.pallets |> Story.map config)
        (Story.fromList "direction" Caret.directions)
        |> withFrontCover (Caret.view (config Black) Caret.Up)


file : Book (Styles s) (Variation v)
file =
    let
        config pallet =
            { pallet = pallet
            , onClick = Just "File clicked!"
            , size = 256
            }
    in
    bookWith "File"
        File.view
        (Story.fromList "pallet" Pallet.pallets |> Story.map config)
        |> withFrontCover (File.view <| config Black)


folder : Book (Styles s) (Variation v)
folder =
    let
        config pallet =
            { pallet = pallet
            , onClick = Just "Folder clicked!"
            , size = 256
            }
    in
    bookWith "Folder"
        Folder.view
        (Story.fromList "pallet" Pallet.pallets |> Story.map config)
        |> withFrontCover (Folder.view <| config Black)


ban : Book (Styles s) (Variation v)
ban =
    let
        config pallet =
            { pallet = pallet
            , onClick = Just "Ban clicked!"
            , size = 256
            }
    in
    bookWith "Ban"
        Ban.view
        (Story.fromList "pallet" Pallet.pallets |> Story.map config)
        |> withFrontCover (Ban.view <| config Black)


book : Book (Styles s) (Variation v)
book =
    let
        config pallet =
            { pallet = pallet
            , onClick = Just "Book clicked!"
            , size = 256
            }
    in
    bookWith "Book"
        Book.view
        (Story.fromList "pallet" Pallet.pallets |> Story.map config)
        |> withFrontCover (Book.view <| config Black)


books : Book (Styles s) (Variation v)
books =
    let
        config pallet =
            { pallet = pallet
            , onClick = Just "Books clicked!"
            , size = 256
            }
    in
    bookWith "Books"
        Books.view
        (Story.fromList "pallet" Pallet.pallets |> Story.map config)
        |> withFrontCover (Books.view <| config Black)


selectBox : Book (Styles s) (Variation v)
selectBox =
    let
        view label disabled selectList =
            SelectBox.view
                { label = label
                , onChange = identity
                , disabled = disabled
                }
                selectList

        short =
            SelectList.fromLists []
                "aaa"
                [ "bbb", "ccc", "ddd", "eee", "fff", "ggg" ]
                |> SelectList.selectAll

        long =
            SelectList.fromLists []
                "hogehogehogehogehoge"
                [ "fugafugafugafuga", "hoga" ]
                |> SelectList.selectAll

        toString selectList =
            SelectList.selected selectList
    in
    bookWith3 "SelectBox"
        view
        (Story.fromList "label"
            [ "a"
            , "middle label"
            , "long long long long long label"
            ]
        )
        (Story.bool "disabled")
        (Story.fromListWith toString "option" (short ++ long))
        |> withFrontCover
            (view "Example Story" False <|
                SelectList.fromLists [ "aa", "bb" ] "cc" [ "dd" ]
            )


toggle : Book (Styles s) (Variation v)
toggle =
    bookWith "Toggle"
        (Toggle.view { name = "On", onClick = "Clicked" })
        (Story.bool "on")
        |> withFrontCover (Toggle.view { name = "On", onClick = "Clicked" } True)


tab : Book (Styles s) (Variation v)
tab =
    bookWith2 "Tab"
        (\selected label ->
            Tab.view { selected = selected, onClick = identity } label
        )
        (Story.bool "selected")
        (Story "label"
            [ "short" => "s"
            , "middle" => "Middle"
            , "long" => "Hogehogehogehoge"
            ]
        )
        |> withFrontCover
            (Tab.view { selected = True, onClick = identity } "Tab Label")


logLine : Book (Styles s) (Variation v)
logLine =
    bookWith2 "LogLine"
        (\id message ->
            LogLine.view { id = id, message = message }
        )
        (Story.fromList "id" [ 1, 99, 999, 9999 ])
        (Story "message"
            [ "empty" => ""
            , "one" => "s"
            , "middle" => "mmmmmmmmmmmmmmmmmmmmmmmm"
            , "long" => "HogehogehogehogeHogehogehogehogeHogehogehogehogeHogeh ogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogeho geHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehogeHogehogehogehoge HogehogehogehogeHogehogehogehogeHogehogehogehoge"
            ]
        )
        |> withFrontCover
            (LogLine.view { id = 0, message = "dummy message" })


main : Bibliopola.Program (Styles s) (Variation v)
main =
    fromShelf styles shelf
