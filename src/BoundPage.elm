module BoundPage exposing (bind, update)

import Arg
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Element exposing (..)
import Html exposing (Html)
import List.Extra as List
import Page
import Random exposing (Generator, Seed)
import Route
import SelectList
import Tree
import Types exposing (..)
import Ui.App.Page as Page
import Url exposing (Url)


bind : ViewConfig view msg -> Seed -> Page view -> BoundPage
bind { msgToString, viewToElement } seed page =
    { label = page.label
    , seeds = SelectList.singleton seed
    , selects = []
    , logs = []
    , view = Page.view { toString = msgToString, toElement = viewToElement, page = page }
    }


update : PageMsg -> BoundPage -> ( BoundPage, Cmd PageMsg )
update msg page =
    case msg of
        LogMsg log ->
            ( { page | logs = log :: page.logs }, Cmd.none )

        RequireNewSeed ->
            ( page, Random.generate GotNewSeed Random.independentSeed )

        GotNewSeed seed ->
            ( { page
                | seeds =
                    SelectList.selectHead page.seeds
                        |> SelectList.insertAfter seed
              }
            , Cmd.none
            )

        ChangeArgSelects selects ->
            ( { page | selects = selects }, Cmd.none )

        ChangeSeeds seeds ->
            ( { page | seeds = seeds }, Cmd.none )
