module Atom.Constant exposing
    ( borderWidth
    , fontSize
    , iconSize
    , roundLength
    , space
    , zero
    , zeroCorner
    )

import Element exposing (modular)


zero : { bottom : Int, left : Int, right : Int, top : Int }
zero =
    { bottom = 0, left = 0, right = 0, top = 0 }


zeroCorner : { topLeft : Int, topRight : Int, bottomRight : Int, bottomLeft : Int }
zeroCorner =
    { topLeft = 0, topRight = 0, bottomRight = 0, bottomLeft = 0 }


fontSize : Int -> Int
fontSize rescale =
    round <| modular 16 1.25 rescale


borderWidth : Int -> Int
borderWidth rescale =
    round <| modular 2 1.25 rescale


roundLength : Int -> Int
roundLength rescale =
    round <| modular 5 1.25 rescale


space : Int -> Int
space rescale =
    round <| modular 5 1.25 rescale


iconSize : Int -> Int
iconSize rescale =
    round <| modular 16 1.75 rescale
