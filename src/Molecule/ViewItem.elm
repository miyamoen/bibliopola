module Molecule.ViewItem exposing (view, viewItem)

import Atom.Caret as Caret
import Atom.File as File
import Atom.Folder as Folder
import Bibliopola exposing (..)
import Color.Pallet exposing (Pallet(..))
import Dict
import Dummy
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Model.Views as Views exposing (..)
import Styles exposing (styles)
import Types exposing (..)


view : Zipper (View s v) -> MyElement s v
view zipper =
    row None
        []
        [ spacer zipper
        , row None
            [ spacing 10, verticalCenter ]
            [ caret zipper
            , row None
                [ spacing 5, verticalCenter ]
                [ icon zipper, el Text [] <| text <| .name <| Zipper.current zipper ]
            ]
        ]


spacer : Zipper (View s v) -> Element (Styles s) vv msg
spacer zipper =
    let
        depth =
            List.length <| Zipper.breadCrumbs zipper
    in
    if depth == 0 then
        empty
    else
        List.repeat (depth - 1) oneSpace
            |> List.concat
            |> flip List.append (lastSpace zipper)
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


lastSpace : Zipper (View s v) -> List (Element (Styles s) vv msg)
lastSpace zipper =
    if Zipper.isEmpty zipper then
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


caret : Zipper (View s v) -> MyElement s v
caret zipper =
    if Zipper.isEmpty zipper then
        empty
    else
        Caret.view
            { size = 16
            , pallet = Grey
            , onClick = Just <| \_ -> SetViews <| Views.toggleTree zipper
            }
        <|
            case .state <| Zipper.current zipper of
                Open ->
                    Caret.Down

                Close ->
                    Caret.Right


icon : Zipper (View s v) -> MyElement s v
icon zipper =
    (if Dict.isEmpty <| .variations <| Zipper.current zipper then
        Folder.view
     else
        File.view
    )
    <|
        { size = 16, pallet = Black, onClick = Nothing }


viewItem : View (Styles s) (Variation v)
viewItem =
    createViewItem "ViewItem"
        view
        ( "views"
        , [ "root" => Dummy.views
          , "ham" => Views.attemptOpenPath [ "ham" ] Dummy.views
          , "egg" => Views.attemptOpenPath [ "egg" ] Dummy.views
          , "boiled_egg" => Views.attemptOpenPath [ "egg", "boiled" ] Dummy.views
          ]
        )
        |> withDefaultVariation (view Dummy.views)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewItem styles viewItem
