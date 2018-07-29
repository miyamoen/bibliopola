module Dummy exposing (..)

import Dict
import Element exposing (text)
import Lazy exposing (lazy)
import Lazy.LList as LList
import Lazy.Tree as Tree exposing (Tree(Tree))
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Route
import Types exposing (..)


model : Model s v
model =
    { styles = []
    , views = views
    , route = Route.View [] <| Dict.fromList []
    }


views : ViewTree s v
views =
    Zipper.fromTree <|
        Tree (item Open "root") <|
            LList.fromList
                [ Tree.singleton (item Open "ham")
                , Tree (emptyItem Close "egg") <|
                    LList.fromList
                        [ Tree.singleton (item Close "boiled")
                        , Tree.singleton (item Close "fried")
                        , Tree.singleton (item Close "scrambled")
                        ]
                , Tree (item Open "spam") <|
                    LList.fromList
                        [ Tree (emptyItem Open "spamspam") <|
                            LList.fromList [ Tree.singleton (item Close "spamspamspam") ]
                        ]
                ]


item : State -> String -> ViewItem s v
item state name =
    { name = name
    , state = state
    , stories = []
    , variations =
        Dict.fromList
            [ "default" => lazy (\_ -> text <| name ++ " view") ]
    }


emptyItem : State -> String -> ViewItem s v
emptyItem state name =
    { name = name
    , state = state
    , stories = []
    , variations = Dict.empty
    }
