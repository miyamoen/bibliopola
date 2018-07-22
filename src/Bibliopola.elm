module Bibliopola exposing (..)

import Element exposing (Element)
import Html
import Lazy exposing (lazy)
import Lazy.Tree as Tree
import Lazy.Tree.Zipper as Zipper
import Style exposing (Style)
import Types exposing (..)
import View exposing (view)


createMainfromViewItem :
    List (Style child childVar)
    -> View child childVar
    -> Program Never (Model child childVar) Msg
createMainfromViewItem styles view =
    createMain
        { views =
            Zipper.fromTree <| Tree.singleton view
        , styles = styles
        }


createViewItem :
    String
    -> (a -> Element child childVar msg)
    -> List ( String, a )
    -> View child childVar
createViewItem name view stories =
    { name = name
    , state = Close
    , stories = List.map Tuple.first stories |> List.singleton
    , variations =
        List.map
            (Tuple.mapSecond
                (\a -> lazy (\() -> view a |> Element.map (toString >> Print)))
            )
            stories
    }


createMain : Model child childVar -> Program Never (Model child childVar) Msg
createMain model =
    Html.program
        { view = view
        , init = ( model, Cmd.none )
        , update = update
        , subscriptions = always Sub.none
        }


update : Msg -> Model child childVar -> ( Model child childVar, Cmd Msg )
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
