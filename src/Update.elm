module Update exposing (init, onUrlChange, onUrlRequest, subscriptions, update)

import Browser exposing (UrlRequest(..))
import Browser.Dom
import Browser.Events exposing (onResize)
import Browser.Navigation as Nav exposing (Key)
import Model.Book as Book
import Model.Shelf as Shelf
import Route exposing (..)
import SelectList
import Task
import Types exposing (..)
import Url exposing (Url)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            Tuple.pair model Cmd.none

        ClickLink (Internal url) ->
            Tuple.pair model
                (Nav.pushUrl model.key <| Url.toString url)

        ClickLink (External url) ->
            Tuple.pair model <| Nav.load url

        ChangeRoute route ->
            Tuple.pair
                { model | shelf = Shelf.attempt (Shelf.findPage route) model.shelf }
                Cmd.none

        RouteError ->
            Tuple.pair model Cmd.none

        SetWindowSize { width, height } ->
            Tuple.pair { model | width = width, height = height }
                Cmd.none

        LogMsg message ->
            let
                log =
                    case model.logs of
                        latest :: _ ->
                            { message = message, id = latest.id + 1 }

                        [] ->
                            { message = message, id = 0 }
            in
            Tuple.pair { model | logs = log :: model.logs } Cmd.none

        ClearLogs ->
            Tuple.pair { model | logs = [] } Cmd.none

        SetShelf shelf ->
            Tuple.pair { model | shelf = shelf }
                (Shelf.route shelf
                    |> Route.url
                    |> Nav.pushUrl model.key
                )

        SetPanel panel ->
            Tuple.pair { model | panel = panel } Cmd.none


init : Shelf -> () -> Url -> Key -> ( Model, Cmd Msg )
init shelf _ url key =
    let
        ( model, cmd ) =
            update (onUrlChange url)
                { shelf = shelf
                , panel =
                    SelectList.fromLists []
                        StoryPanel
                        [ MsgLoggerPanel, CreditPanel ]
                , logs = []
                , key = key
                , width = 0
                , height = 0
                }
    in
    Tuple.pair model <|
        Cmd.batch [ getWindowSize, cmd ]


getWindowSize : Cmd Msg
getWindowSize =
    Task.map
        (\{ viewport } ->
            { width = floor viewport.width
            , height = floor viewport.height
            }
        )
        Browser.Dom.getViewport
        |> Task.perform SetWindowSize


onUrlRequest : UrlRequest -> Msg
onUrlRequest request =
    ClickLink request


onUrlChange : Url -> Msg
onUrlChange url =
    Route.parse url
        |> Maybe.map ChangeRoute
        |> Maybe.withDefault RouteError


subscriptions : Model -> Sub Msg
subscriptions _ =
    onResize (\width height -> SetWindowSize { width = width, height = height })
