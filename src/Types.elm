module Types exposing
    ( Arg
    , ArgType(..)
    , ArgView(..)
    , Book
    , BookArg
    , BookModel
    , Item
    , Msg(..)
    , Page(..)
    , PageMsg(..)
    , Select(..)
    , Shelf
    , Stitcher
    , ToString
    , UnboundBook
    )

import Browser exposing (UrlRequest)
import Browser.Dom exposing (Viewport)
import Browser.Navigation exposing (Key)
import Element exposing (Element)
import Html exposing (Html)
import Random exposing (Seed)
import Tree exposing (Tree)


type Msg
    = NoOp



---------------- UnboundBook ----------------


type alias UnboundBook view =
    { book : BookArg -> ( view, List String )
    , args : List ArgView
    }



-------- Arg --------


{-| 見たいviewにいれる引数
-}
type alias Arg a =
    { toString : ToString a
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
type ArgView
    = RandomArgView
    | ListArgView String (List String)



---------------- Book ----------------


{-| seedはhistoryになる予定
-}
type alias BookModel =
    { seed : Seed
    , selects : List Select
    , book : Book
    }


type alias BookArg =
    { seed : Seed, selects : List Select }


type alias Book =
    BookArg -> Page


type Page
    = HtmlPage (Html PageMsg)
    | ElementPage (Element PageMsg)


type alias Stitcher view =
    view -> Page


type PageMsg
    = LogMsg String
    | RequireNewSeed


type Select
    = Select Int
    | RandomSelect



---------------- Shelf ----------------


type alias Shelf =
    Tree Item


type alias Item =
    { book : BookModel
    , label : String
    }
