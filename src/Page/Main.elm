module Page.Main exposing (view)

import Atom.Constant as Constant
import Element exposing (..)
import Element.Font as Font
import Model.Shelf as Shelf
import Organism.BookPage as BookPage
import Organism.Panel as Panel
import Organism.ShelfTree as ShelfTree
import Types exposing (..)


view : Maybe (Element String) -> SubModel a -> Element Msg
view front model =
    column
        [ width fill
        , height fill
        , clip
        , padding space
        , spacing space
        , Font.family
            [ Font.external
                { url = "https://fonts.googleapis.com/css?family=Expletus+Sans"
                , name = "Expletus Sans"
                }
            ]
        ]
        [ row [ height <| px <| restHeight model.height, spacing space ]
            [ if Shelf.hasShelves <| Shelf.root model.shelf then
                el
                    [ scrollbars
                    , width <| px <| treeWidth model.shelf
                    , height fill
                    ]
                <|
                    ShelfTree.view model.shelf

              else
                none
            , el
                [ scrollbars
                , width <| px <| restWidth model.width model.shelf
                , height fill
                ]
              <|
                case ( front, Shelf.hasShelves (Shelf.root model.shelf) && Shelf.depth model.shelf == 0 ) of
                    ( Just frontEl, True ) ->
                        Element.map (always NoOp) frontEl

                    _ ->
                        BookPage.view model.shelf
            ]
        , el [ scrollbarY, clipX, height <| px panelHeight, width fill ] <|
            Panel.view model
        ]


restHeight : Int -> Int
restHeight full =
    full - panelHeight - space * 3


panelHeight : Int
panelHeight =
    210


treeWidth : Shelf -> Int
treeWidth shelf =
    if Shelf.hasShelves <| Shelf.root shelf then
        200

    else
        0


restWidth : Int -> Shelf -> Int
restWidth full shelf =
    full - treeWidth shelf - space * 3


space : Int
space =
    Constant.space 1
