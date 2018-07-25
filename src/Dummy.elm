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


views : Zipper (View s v)
views =
    Zipper.fromTree <|
        Tree.tree (item "root") <|
            LList.fromList
                [ Tree.singleton (item "ham")
                , Tree.tree (item "egg") <|
                    LList.fromList
                        [ Tree.singleton (item "boiled")
                        , Tree.singleton (item "fried")
                        , Tree.singleton (item "scrambled")
                        ]
                , Tree.tree (item "spam") <|
                    LList.fromList
                        [ Tree.tree (item "spamspam") <|
                            LList.fromList [ Tree.singleton (item "spamspamspam") ]
                        ]
                ]


item : String -> View s v
item name =
    { name = name
    , state = Close
    , stories = [ "arg1" => [ "default" ] ]
    , variations =
        Dict.fromList
            [ "default" => lazy (\_ -> text <| name ++ " view") ]
    }
