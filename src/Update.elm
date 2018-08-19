module Update exposing (update)

import Model.Shelf as Shelf
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
            { model | logs = log :: model.logs } => Cmd.none

        ClearLogs ->
            { model | logs = [] } => Cmd.none

        SetRoute route ->
            { model | route = route } => Cmd.none

        SetShelf shelf ->
            { model | shelf = Shelf.moveToRoot shelf } => Cmd.none

        SetShelfWithRoute shelf ->
            let
                ( model_, cmd ) =
                    update (GoToRoute <| Shelf.route shelf) model
            in
            { model_ | shelf = Shelf.moveToRoot shelf } => cmd

        GoToRoute route ->
            model
                => (if Route.isEqualPath model.route route then
                        Route.modifyUrl route
                    else
                        Route.newUrl route
                   )

        SetPanel panel ->
            { model | panel = panel } => Cmd.none
