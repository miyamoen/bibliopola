module Molecule.ShelfLine exposing (view)

import Atom.Caret as Caret
import Atom.File as File
import Atom.Folder as Folder
import Color.Pallet exposing (Pallet(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Model.Shelf as Shelf exposing (..)
import Types exposing (..)


view : Shelf s v -> BibliopolaElement s v
view shelf =
    row None
        []
        [ spacer shelf
        , row None
            [ spacing 10, verticalCenter ]
            [ caret shelf
            , row None
                (if Shelf.hasNoPage shelf then
                    [ spacing 5, verticalCenter ]
                 else
                    [ onClick <| GoToRoute <| Shelf.route shelf
                    , inlineStyle [ "cursor" => "pointer" ]
                    , spacing 5
                    , verticalCenter
                    ]
                )
                [ icon shelf
                , el Text [] <| text <| Shelf.name shelf
                ]
            ]
        ]


spacer : Shelf s v -> Element (Styles s) vv msg
spacer shelf =
    let
        depth =
            Shelf.depth shelf
    in
    if depth == 0 then
        empty
    else
        List.repeat (depth - 1) oneSpace
            |> List.concat
            |> flip List.append (lastSpace shelf)
            |> row None []


oneSpace : List (Element (Styles s) v msg)
oneSpace =
    [ el None [ width <| px 7 ] empty
    , el None
        [ width <| px 0
        , inlineStyle [ "border-left" => borderCss ]
        ]
        empty
    , el None [ width <| px 7 ] empty
    ]


lastSpace : Shelf s v -> List (Element (Styles s) vv msg)
lastSpace shelf =
    if not <| Shelf.hasBooks shelf then
        [ el None [ width <| px 7 ] empty
        , el None
            [ width <| px 0
            , inlineStyle [ "border-left" => borderCss ]
            ]
            empty
        , el None
            [ width <| px <| 7 + 16
            , height <| px 12
            , inlineStyle [ "border-bottom" => borderCss ]
            ]
            empty
        , el None [ width <| px 10 ] empty
        ]
    else
        [ el None [ width <| px 7 ] empty
        , el None
            [ width <| px 0
            , inlineStyle [ "border-left" => borderCss ]
            ]
            empty
        , el None
            [ width <| px 5
            , height <| px 12
            , inlineStyle [ "border-bottom" => borderCss ]
            ]
            empty
        , el None [ width <| px 2 ] empty
        ]


borderCss : String
borderCss =
    "2px solid rgba(138, 142, 180, 0.22)"


caret : Shelf s v -> BibliopolaElement s v
caret shelf =
    if not <| Shelf.hasBooks shelf then
        empty
    else
        Caret.view
            { size = 16
            , pallet = Grey
            , onClick = Just <| \_ -> SetShelf <| Shelf.toggleShelf shelf
            }
        <|
            case Shelf.state shelf of
                Open ->
                    Caret.Down

                Close ->
                    Caret.Right


icon : Shelf s v -> BibliopolaElement s v
icon shelf =
    (if Shelf.hasNoPage shelf then
        Folder.view
     else
        File.view
    )
    <|
        { size = 16, pallet = Black, onClick = Nothing }
