module Bibliopola exposing (..)

import Dict
import Element exposing (Element)
import Lazy exposing (lazy)
import Lazy.Tree as Tree
import Lazy.Tree.Zipper as Zipper
import Navigation
import Route
import Style exposing (Style)
import Types exposing (..)
import View exposing (view)


createMainFromViewItem :
    List (Style child childVar)
    -> View child childVar
    -> MyProgram child childVar
createMainFromViewItem styles view =
    createMain
        { route = Route.View [] <| Dict.fromList []
        , views =
            Zipper.fromTree <| Tree.singleton view
        , styles = styles
        }


createViewItem :
    String
    -> (a -> Element child childVar msg)
    -> ( String, List ( String, a ) )
    -> View child childVar
createViewItem name view ( storyName, stories ) =
    { name = name
    , state = Close
    , stories = [ storyName => List.map Tuple.first stories ]
    , variations =
        List.map
            (Tuple.mapSecond
                (\a -> lazy (\() -> view a |> Element.map (toString >> Print)))
            )
            stories
            |> Dict.fromList
    }


withDefaultVariation :
    Element child childVar msg
    -> View child childVar
    -> View child childVar
withDefaultVariation view viewItem =
    { viewItem
        | variations =
            viewItem.variations
                |> Dict.insert
                    "default"
                    (lazy <| \_ -> Element.map (toString >> Print) view)
    }


createMain : Model child childVar -> MyProgram child childVar
createMain model =
    Navigation.program (Route.route >> SetRoute)
        { view = view
        , init =
            \location ->
                ( { model | route = Route.route location }, Cmd.none )
        , update = update
        , subscriptions = always Sub.none
        }


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
            { model | views = views } => Cmd.none
