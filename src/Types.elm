module Types exposing (..)

import Color.Pallet exposing (Pallet)
import Dict exposing (Dict)
import Element exposing (Element)
import Lazy exposing (Lazy)
import Lazy.Tree.Zipper exposing (Zipper)
import Route exposing (Route)
import Style exposing (Style)


type Msg
    = NoOp
    | SetRoute Route
    | Print String


type alias Model child childVar =
    { route : Route
    , views : Zipper (View child childVar)
    , styles : List (Style child childVar)
    }


type alias View child childVar =
    { name : String
    , state : State
    , stories : List ( String, List String )
    , variations : Dict String (Lazy (Element child childVar Msg))
    }


type State
    = Close
    | Open


type alias MyElement child childVar =
    Element (Styles child) (Variation childVar) Msg


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
