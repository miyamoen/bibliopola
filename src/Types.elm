module Types exposing
    ( Arg
    , ArgSelect
    , ArgSelectType(..)
    , ArgType(..)
    , ArgView
    , ArgViewType(..)
    , Book
    , BookItem
    , Model
    , Msg(..)
    , Page
    , PageArg
    , PageModel
    , PageMsg(..)
    , ToString
    , TreeItem
    )

import Browser exposing (UrlRequest)
import Browser.Dom exposing (Viewport)
import Browser.Navigation exposing (Key)
import Element exposing (Attribute, Element)
import Html exposing (Html)
import Random exposing (Seed)
import SelectList exposing (SelectList)
import Tree exposing (Tree)



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
    , pages : List (Page view)
    }



---------------- Bibliopola ----------------


type PageMsg
    = LogMsg String
    | RequireNewSeed
    | ChangeArgSelects (List ArgSelect)
    | ChangeSeeds (SelectList Seed)


{-| -}
type alias PageModel =
    { label : String
    , seeds : SelectList Seed
    , selects : List ArgSelect
    , view : List (Attribute PageMsg) -> SelectList Seed -> List ArgSelect -> Element PageMsg
    }


type alias Model =
    { book : Tree TreeItem }


type alias TreeItem =
    { label : String, pages : List PageModel }


type Msg
    = NoOp
    | PageMsg PageMsg
