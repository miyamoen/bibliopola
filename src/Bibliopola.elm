module Bibliopola exposing (toPageModel)

import Arg
import Browser
import Browser.Navigation exposing (Key)
import Element exposing (..)
import Html exposing (Html)
import List.Extra as List
import Page
import Random exposing (Generator, Seed)
import SelectList
import Tree
import Types exposing (..)
import Url exposing (Url)



-- type alias Page view =
--     { label : String
--     , view : PageArg -> ( view, List String )
--     , args : List ArgView
--     }
--
-- {-| -}
-- type alias PageModel =
--     { label : String
--     , seeds : SelectList Seed
--     , selects : List ArgSelect
--     , view : Html PageMsg
--     }
--     Browser.application
--     { init :   flags -> Url.Url -> Browser.Navigation.Key -> ( model, Platform.Cmd.Cmd msg )
--     , view : model -> Browser.Document msg
--     , update : msg -> model -> ( model
--     , Platform.Cmd.Cmd msg )
--     , subscriptions : model -> Platform.Sub.Sub msg
--     , onUrlRequest : Browser.UrlRequest -> msg
--     , onUrlChange : Url.Url -> msg
--     }
--
-- init :  -> () -> Url -> Key -> (Model, Cmd Msg)
