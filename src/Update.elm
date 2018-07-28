module Update exposing (update)

import Lazy.Tree.Zipper as Zipper
import Types exposing (..)


update : Msg s v -> Model s v -> ( Model s v, Cmd (Msg s v) )
update msg model =
    case msg of
        NoOp ->
            model => Cmd.none

        Print print ->
            let
                _ =
                    Debug.log "Msg" print
            in
            model => Cmd.none

        SetRoute route ->
            { model | route = Debug.log "route" route } => Cmd.none

        SetViews views ->
            { model | views = Zipper.root views } => Cmd.none
