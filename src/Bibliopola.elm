module Bibliopola exposing (Program, displayPage, identityConfig)

import Arg
import Book
import BoundPage
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Element exposing (..)
import Html exposing (Html)
import List.Extra as List
import Page
import Random exposing (Generator, Seed)
import Route
import SelectList
import Types exposing (..)
import Ui
import Ui.App.Page as Page
import Url exposing (Url)


type alias Program =
    Platform.Program () Model Msg


identityConfig : ViewConfig (Element String) String
identityConfig =
    { viewToElement = identity, msgToString = identity }


displayPage : ViewConfig view msg -> Page view -> Program
displayPage config page =
    Browser.application
        { init = initPageMode config page
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangeUrl
        }


initPageMode : ViewConfig view msg -> Page view -> () -> Url -> Key -> ( Model, Cmd Msg )
initPageMode config page _ url key =
    ( { mode = PageMode <| BoundPage.bind config (Random.initialSeed 1234) page
      , key = key
      , route = Route.parse url
      }
    , Cmd.map (PageMsg { pagePath = page.label, bookPaths = [] }) BoundPage.generateSeed
    )


view : Model -> Document Msg
view model =
    { title = "Bibliopola"
    , body = [ Ui.view model ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        PageMsg path pageMsg ->
            case model.mode of
                BookMode book ->
                    let
                        ( newBook, cmd ) =
                            Book.updatePage path (BoundPage.update pageMsg) book
                    in
                    ( { model | mode = BookMode newBook }, Cmd.map (PageMsg path) cmd )

                PageMode page ->
                    let
                        ( newPage, cmd ) =
                            BoundPage.update pageMsg page
                    in
                    ( { model | mode = PageMode newPage }, Cmd.map (PageMsg path) cmd )

        ClickedLink urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        ChangeUrl url ->
            ( { model | route = Route.parse url }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
