module Types exposing
    ( AbstractBookItem
    , Arg
    , ArgSelect
    , ArgSelectType(..)
    , ArgView
    , ArgViewType(..)
    , Book
    , BookItem
    , BoundBook
    , BoundBookItem
    , BoundPage
    , Mode(..)
    , Model
    , Msg(..)
    , Page
    , PageMsg(..)
    , PagePath
    , PageSeed
    , Route(..)
    , Tab(..)
    , ToString
    , ViewConfig
    )

import Browser exposing (UrlRequest)
import Browser.Dom exposing (Viewport)
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Element exposing (Attribute, Element)
import Html exposing (Html)
import Lazy.Tree exposing (Tree)
import Random exposing (Seed)
import SelectList exposing (SelectList)
import Url exposing (Url)



---------------- Page ----------------


type alias Page view =
    { label : String
    , view : PageSeed -> ( view, List ArgView )
    }


type alias ArgView =
    { type_ : ArgViewType
    , label : String
    , value : String
    }


type alias ArgSelect =
    { type_ : ArgSelectType
    , index : Maybe Int
    }


type ArgSelectType
    = ListArgSelect
    | RandomArgSelect


type alias PageSeed =
    { seed : Seed, selects : List ArgSelect }



-------- Arg --------


{-| 見たいviewにいれる引数
-}
type alias Arg a =
    { label : String
    , toString : ToString a
    , generator : Random.Generator a
    , list : Maybe ( a, List a )
    }


type alias ToString a =
    a -> String


{-| uiを生成できるように
-}
type ArgViewType
    = RandomArgView
    | ListArgView String (List String)



---------------- Book ----------------


type alias Book view =
    Tree (BookItem view)


type alias BookItem view =
    { label : String
    , pages : Dict String (Page view)
    }


type alias BoundBookItem =
    { label : String
    , pages : Dict String BoundPage
    , open : Bool
    }


type alias BoundBook =
    Tree BoundBookItem


type alias PagePath =
    { pagePath : String, bookPaths : List String }


type alias AbstractBookItem item page =
    { item | label : String, pages : Dict String page }



---------------- Bibliopola ----------------


type PageMsg
    = LogMsg String
    | RequireNewSeed
    | GotNewSeed Seed
    | ChangeArgSelects (List ArgSelect)
    | ChangeSeeds (SelectList Seed)


{-| -}
type alias BoundPage =
    { label : String
    , seeds : SelectList Seed
    , selects : List ArgSelect
    , logs : List String
    , view :
        SelectList Seed
        -> List ArgSelect
        ->
            { page : List (Attribute PageMsg) -> Element PageMsg
            , args : List (Attribute PageMsg) -> Element PageMsg
            }
    }


type alias Model =
    { mode : Mode
    , route : Route
    , key : Key
    , tabs : SelectList Tab
    }


type alias ViewConfig view msg =
    { viewToElement : view -> Element msg
    , msgToString : msg -> String
    }


type Route
    = TopRoute
    | PageRoute PagePath
    | BrokenRoute String
    | NotFoundRoute String


type Mode
    = BookMode BoundBook
    | PageMode BoundPage


type Msg
    = NoOp
    | PageMsg PagePath PageMsg
    | OpenAllBook
    | CloaseAllBook
    | OpenBook (List String)
    | CloseBook (List String)
    | ChangeTabs (SelectList Tab)
    | ClickedLink UrlRequest
    | ChangeUrl Url



---------------- UI ----------------


type Tab
    = ArgsTab
    | SeedTab
