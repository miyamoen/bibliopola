module Dummy exposing (..)

import Dict
import Element exposing (text)
import Lazy exposing (lazy)
import Lazy.LList as LList
import Lazy.Tree as Tree
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Route
import Types exposing (..)


model : Model s v
model =
    { styles = []
    , views = views
    , route = Route.View [] <| Dict.fromList []
    }


views : Zipper (ViewItem s v)
views =
    Zipper.fromTree <|
        Tree.tree (item Open "root") <|
            LList.fromList
                [ Tree.singleton (item Open "ham")
                , Tree.tree (emptyItem Close "egg") <|
                    LList.fromList
                        [ Tree.singleton (item Close "boiled")
                        , Tree.singleton (item Close "fried")
                        , Tree.singleton (item Close "scrambled")
                        ]
                , Tree.tree (item Open "spam") <|
                    LList.fromList
                        [ Tree.tree (emptyItem Open "spamspam") <|
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
