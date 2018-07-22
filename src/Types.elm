module Types exposing (..)

import Element exposing (Element)
import Lazy exposing (Lazy)
import Lazy.Tree.Zipper exposing (Zipper)
import Style exposing (Style)


type Msg
    = NoOp
    | Print String


type alias Model child childVar =
    { views : Zipper (View child childVar)
    , styles : List (Style child childVar)
    }


type alias View child childVar =
    { name : String
    , state : State
    , stories : List (List String)
    , variations : List ( String, Lazy (Element child childVar Msg) )
    }


type State
    = Close
    | Open
    | Select


type alias MyElement child childVar =
    Element (Styles child) (Variation childVar) Msg


type Styles child
    = None
    | Child child


type Variation childVar
    = NoVar
    | ChildVar childVar


(=>) : a -> b -> ( a, b )
(=>) =
    (,)
infixl 0 =>
