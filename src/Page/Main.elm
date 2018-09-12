module Page.Main exposing (view)

import Atom.Constant as Constant
import Element exposing (..)
import Element.Font as Font
import Organism.BookPage as BookPage
import Organism.Panel as Panel
import Organism.ShelfTree as ShelfTree
import Types exposing (..)


view : SubModel a -> Element Msg
view model =
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
            [ el
                [ scrollbars
                , width <| px treeWidth
                , height fill
                ]
              <|
                ShelfTree.view model.shelf
            , el
                [ scrollbars
                , width <| px <| restWidth model.width
                , height fill
                ]
              <|
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


treeWidth : Int
treeWidth =
    200


restWidth : Int -> Int
restWidth full =
    full - treeWidth - space * 3


space : Int
space =
    Constant.space 1
