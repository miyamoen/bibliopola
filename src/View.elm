module View exposing (..)

import Element exposing (..)
import Html exposing (Html)
import Lazy
import Lazy.Tree.Zipper as Zipper
import Style exposing (..)
import Style.Sheet
import Types exposing (..)


view : Model child childVar -> Html Msg
view model =
    layout (styleSheet model.styles) <|
        column None
            []
            [ currentView <|
                Zipper.current model.views
            ]


currentView : View child childVar -> MyElement child childVar
currentView { variations } =
    variations
        |> List.head
        |> Maybe.map (Tuple.second >> Lazy.force)
        |> Maybe.withDefault (text "empty")
        |> Element.mapAll identity Child ChildVar


styleSheet :
    List (Style child childVar)
    -> StyleSheet (Styles child) (Variation childVar)
styleSheet child =
    Style.styleSheet
        [ style None []
        , Style.Sheet.merge <| Style.Sheet.map Child ChildVar child
        ]
