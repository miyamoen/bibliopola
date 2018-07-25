module Types exposing (..)

import Color.Pallet exposing (Pallet)
import Dict exposing (Dict)
import Element exposing (Element)
import Lazy exposing (Lazy)
import Lazy.Tree.Zipper exposing (Zipper)
import Route exposing (Route)
import Style exposing (Style)


type Msg child childVar
    = NoOp
    | Print String
    | SetRoute Route
    | SetViews (Zipper (View child childVar))


type alias Model child childVar =
    { route : Route
    , views : Zipper (View child childVar)
    , styles : List (Style child childVar)
    }


type alias View child childVar =
    { name : String
    , state : State
    , stories : List ( String, List String )
    , variations : Dict String (Lazy (Element child childVar (Msg child childVar)))
    }


type State
    = Close
    | Open



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
