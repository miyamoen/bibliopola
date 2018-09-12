module Organism.Panel exposing (view)

import Atom.Constant exposing (borderWidth, roundLength, zero, zeroCorner)
import Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Model.Shelf as Shelf
import Molecule.Tabs as Tabs
import Organism.Credit as Credit
import Organism.Logger as Logger
import Organism.Stories as Stories
import SelectList exposing (SelectList)
import Types exposing (..)


view : SubModel a -> Element Msg
view ({ panel, logs, shelf } as model) =
    column
        [ width fill, height fill ]
        [ Tabs.view panelToString panel
            |> Element.map SetPanel
        , el
            [ padding 10
            , width fill
            , height fill
            , Border.roundEach
                { zeroCorner
                    | bottomLeft = roundLength 1
                    , bottomRight = roundLength 1
                }
            , Border.color Color.alphaGrey
            , Border.widthEach
                { zero
                    | right = borderWidth 1
                    , left = borderWidth 1
                    , bottom = borderWidth 1
                }
            , Background.color Color.white
            ]
          <|
            case SelectList.selected panel of
                StoryPanel ->
                    Stories.view shelf

                MsgLoggerPanel ->
                    Logger.view logs

                CreditPanel ->
                    Credit.view
        ]


panelToString : PanelItem -> String
panelToString panelItem =
    case panelItem of
        StoryPanel ->
            "Stories"

        MsgLoggerPanel ->
            "Logger"

        CreditPanel ->
            "Credit"
