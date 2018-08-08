module Types exposing (..)

import Color.Pallet exposing (Pallet)
import Dict exposing (Dict)
import Element exposing (Element)
import Lazy exposing (Lazy)
import Lazy.Tree.Zipper exposing (Zipper)
import Route exposing (Route)
import SelectList exposing (SelectList)
import Style exposing (Style)


type Msg style variation
    = NoOp
    | LogMsg String
    | ClearLogs
    | SetRoute Route
    | GoToRoute Route
    | SetViewTree (ViewTree style variation)
    | SetViewTreeWithRoute (ViewTree style variation)
    | SetPanel Panel


type alias Model style variation =
    { route : Route
    , views : ViewTree style variation
    , styles : List (Style style variation)
    , panel : Panel
    , logs : List Log
    }


type alias ViewItem style variation =
    { name : String
    , state : State
    , stories : List ( String, List String )
    , variations : Dict String (Lazy (Element style variation (Msg style variation)))
    , form : { stories : Dict String String, storyOn : Bool }
    }


type alias ViewTree style variation =
    Zipper (ViewItem style variation)


type State
    = Close
    | Open


type alias Panel =
    SelectList PanelItem


type PanelItem
    = StoryPanel
    | MsgLoggerPanel
    | AuthorPanel


type alias Log =
    { message : String, id : Int }



-- alias


type alias MyElement style variation =
    Element (Styles style) (Variation variation) (Msg style variation)


type alias BibliopolaProgram style variation =
    Program Never (Model style variation) (Msg style variation)



-- style


type Styles style
    = None
    | Text
    | Box
    | Child style


type Variation variation
    = NoVar
    | PalletVar Pallet
    | ChildVar variation


(=>) : a -> b -> ( a, b )
(=>) =
    (,)
infixl 0 =>
