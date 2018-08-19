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
    | SetShelf (Shelf style variation)
    | SetShelfWithRoute (Shelf style variation)
    | SetPanel Panel


type alias Model style variation =
    { route : Route
    , shelf : Shelf style variation
    , styles : List (Style style variation)
    , panel : Panel
    , logs : List Log
    }


type Shelf style variation
    = Shelf (Zipper (Book style variation))


type Book style variation
    = Book
        { name : String
        , pages : Dict String (LazyElement style variation)
        , stories : List ( String, SelectList String )
        , storyModeOn : Bool
        , state : State
        }


type alias LazyElement style variation =
    Lazy (Element style variation (Msg style variation))


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


type alias BibliopolaElement style variation =
    Element (Styles style) (Variation variation) (Msg style variation)


type alias Program style variation =
    Platform.Program Never (Model style variation) (Msg style variation)



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
