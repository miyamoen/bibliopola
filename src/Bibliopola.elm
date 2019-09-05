module Bibliopola exposing (Program, displayBook, displayPage, identityConfig)

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


displayBook : ViewConfig view msg -> Book view -> Program
displayBook config book =
    Browser.application
        { init = initBookMode config book
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangeUrl
        }


initBookMode : ViewConfig view msg -> Book view -> () -> Url -> Key -> ( Model, Cmd Msg )
initBookMode config book _ url key =
    ( { mode = BookMode <| Book.bind config (Random.initialSeed 1234) book
      , key = key
      , route = Route.parse url
      }
    , Cmd.batch <|
        List.map (\path -> Cmd.map (PageMsg path) BoundPage.generateSeed) <|
            Book.allPaths book
    )


view : Model -> Document Msg
view model =
    { title = "Bibliopola"
    , body = Ui.view model
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

        CloaseAllBook ->
            case model.mode of
                BookMode book ->
                    ( { model | mode = BookMode <| Book.closeAll book }, Cmd.none )

                PageMode page ->
                    ( model, Cmd.none )

        OpenAllBook ->
            case model.mode of
                BookMode book ->
                    ( { model | mode = BookMode <| Book.openAll book }, Cmd.none )

                PageMode page ->
                    ( model, Cmd.none )

        CloseBook bookPaths ->
            case model.mode of
                BookMode book ->
                    ( { model | mode = BookMode <| Book.closeAtPaths bookPaths book }, Cmd.none )

                PageMode page ->
                    ( model, Cmd.none )

        OpenBook bookPaths ->
            case model.mode of
                BookMode book ->
                    ( { model | mode = BookMode <| Book.openThroughPaths bookPaths book }, Cmd.none )

                PageMode page ->
                    ( model, Cmd.none )

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
