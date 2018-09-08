module Types exposing
    ( Book(..)
    , Log
    , Model
    , Msg(..)
    , Panel
    , PanelItem(..)
    , ParsedRoute
    , Shelf(..)
    , ShelfPath
    , SubModel
    )

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Element exposing (Element)
import SelectList exposing (SelectList)
import Tree.Zipper exposing (Zipper)


type Msg
    = NoOp
    | ClickLink UrlRequest
    | ChangeRoute ParsedRoute
    | RouteError
    | LogMsg String
    | ClearLogs
    | SetShelf Shelf
    | SetPanel Panel


type alias Model =
    SubModel { key : Key }


type alias SubModel a =
    { a
        | shelf : Shelf
        , panel : Panel
        , logs : List Log
    }


type Shelf
    = Shelf (Zipper Book)


type Book
    = Book
        { title : String
        , pages : Dict String (Element Msg)
        , stories : List ( String, SelectList String )
        , isOpen : Bool
        , shelfIsOpen : Bool
        }


type alias ShelfPath =
    List String


type alias Panel =
    SelectList PanelItem


type PanelItem
    = StoryPanel
    | MsgLoggerPanel
    | AuthorPanel


type alias Log =
    { message : String, id : Int }


type alias ParsedRoute =
    { path : List String
    , query : List ( String, String )
    }
