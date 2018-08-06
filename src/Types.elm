module Types exposing (..)

import Color.Pallet exposing (Pallet)
import Dict exposing (Dict)
import Element exposing (Element)
import Lazy exposing (Lazy)
import Lazy.Tree.Zipper exposing (Zipper)
import Route exposing (Route)
import SelectList exposing (SelectList)
import Style exposing (Style)


type Msg child childVar
    = NoOp
    | Print String
    | SetRoute Route
    | GoToRoute Route
    | SetViewTree (ViewTree child childVar)
    | SetViewTreeWithRoute (ViewTree child childVar)
    | SetPanel Panel


type alias Model child childVar =
    { route : Route
    , views : ViewTree child childVar
    , styles : List (Style child childVar)
    , panel : Panel
    }


type alias ViewItem child childVar =
    { name : String
    , state : State
    , stories : List ( String, List String )
    , variations : Dict String (Lazy (Element child childVar (Msg child childVar)))
    , form : { stories : Dict String String, storyOn : Bool }
    }


type alias ViewTree child childVar =
    Zipper (ViewItem child childVar)


type State
    = Close
    | Open


type alias Panel =
    SelectList PanelItem


type PanelItem
    = StoryPanel



-- alias


type alias MyElement child childVar =
    Element (Styles child) (Variation childVar) (Msg child childVar)


type alias MyProgram child childVar =
    Program Never (Model child childVar) (Msg child childVar)



-- style


type Styles child
    = None
    | Text
    | Box
    | Child child


type Variation childVar
    = NoVar
    | PalletVar Pallet
    | ChildVar childVar


(=>) : a -> b -> ( a, b )
(=>) =
    (,)
infixl 0 =>
