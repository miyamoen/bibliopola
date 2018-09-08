module Atom.Constant exposing (borderWidth, fontSize, roundLength, space)

import Element exposing (modular)


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
