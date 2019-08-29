module Bibliopola exposing (Program, displayPage)

import Arg
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
import Tree
import Types exposing (..)
import Ui.App.Page as Page
import Url exposing (Url)


type alias Program =
    Platform.Program () Model Msg


displayPage : ViewConfig view msg -> Page view -> Program
displayPage config page =
    Browser.application
        { init = init <| PageMode <| BoundPage.bind config (Random.initialSeed 1234) page
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangeUrl
        }


init : Mode -> () -> Url -> Key -> ( Model, Cmd Msg )
init mode _ url key =
    ( { mode = mode, key = key, route = Route.parse url }, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "Bibliopola"
    , body = []
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        PageMsg pageKey bookKeys pageMsg ->
            case model.mode of
                BookMode tree ->
                    Debug.todo "String.String"

                PageMode page ->
                    let
                        ( newPage, cmd ) =
                            BoundPage.update pageMsg page
                    in
                    ( { model | mode = PageMode newPage }, Cmd.map (PageMsg pageKey bookKeys) cmd )

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
