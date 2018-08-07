module Update exposing (update)

import Lazy.Tree.Zipper as Zipper
import Model.ViewTree exposing (getRoute)
import Route exposing (..)
import Types exposing (..)


update : Msg s v -> Model s v -> ( Model s v, Cmd (Msg s v) )
update msg model =
    case msg of
        NoOp ->
            model => Cmd.none

        LogMsg message ->
            let
                log =
                    case model.logs of
                        latest :: _ ->
                            { message = message, id = latest.id + 1 }

                        [] ->
                            { message = message, id = 0 }
            in
            { model | logs = Debug.log "log" log :: model.logs } => Cmd.none

        ClearLogs ->
            { model | logs = [] } => Cmd.none

        SetRoute route ->
            { model | route = route } => Cmd.none

        SetViewTree tree ->
            { model | views = Zipper.root tree } => Cmd.none

        SetViewTreeWithRoute tree ->
            let
                ( model_, cmd ) =
                    update (GoToRoute <| getRoute tree) model
            in
            { model_ | views = Zipper.root tree } => cmd

        GoToRoute route ->
            model
                => (if Route.isEqualPath model.route route then
                        Route.modifyUrl route
                    else
                        Route.newUrl route
                   )

        SetPanel panel ->
            { model | panel = panel } => Cmd.none
