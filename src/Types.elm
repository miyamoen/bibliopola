module Types exposing
    ( Arg
    , ArgSelect
    , ArgSelectType(..)
    , ArgType(..)
    , ArgView
    , ArgViewType(..)
    , Book
    , BookItem
    , BoundPage
    , Mode(..)
    , Model
    , Msg(..)
    , Page
    , PageArg
    , PageMsg(..)
    , Route(..)
    , ToString
    , ViewConfig
    )

import Browser exposing (UrlRequest)
import Browser.Dom exposing (Viewport)
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Element exposing (Attribute, Element)
import Html exposing (Html)
import Random exposing (Seed)
import SelectList exposing (SelectList)
import Tree exposing (Tree)
import Url exposing (Url)



---------------- Page ----------------


type alias Page view =
    { label : String
    , view : PageArg -> ( view, List ArgView )
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


type alias PageArg =
    { seed : Seed, selects : List ArgSelect }



-------- Arg --------


{-| 見たいviewにいれる引数
-}
type alias Arg a =
    { label : String
    , toString : ToString a
    , type_ : ArgType a
    }


type ArgType a
    = GenArg (Random.Generator a)
    | ListArg a (List a)
    | GenOrListArg (Random.Generator a) a (List a)


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
    }


type alias ViewConfig view msg =
    { viewToElement : view -> Element msg
    , msgToString : msg -> String
    }


type Route
    = TopRoute
    | PageRoute String (List String)
    | BrokenRoute String
    | NotFoundRoute String


type Mode
    = BookMode (Tree { label : String, pages : Dict String BoundPage })
    | PageMode BoundPage


type Msg
    = NoOp
    | PageMsg String (List String) PageMsg
    | ClickedLink UrlRequest
    | ChangeUrl Url
