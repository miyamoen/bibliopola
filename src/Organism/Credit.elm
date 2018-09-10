module Organism.Credit exposing (view)

import Atom.Constant exposing (fontSize)
import Color
import Element exposing (..)
import Element.Font as Font


view : Element msg
view =
    column
        [ spacing 10
        , Font.size <| fontSize 1
        , Font.italic
        , Font.underline
        , Font.color Color.blue
        ]
        [ newTabLink [] { label = text "package site", url = packageLink }
        , newTabLink [] { label = text "GitHub", url = gitHubLink }
        , newTabLink [] { label = text "author twitter", url = twitterLink }
        ]


gitHubLink : String
gitHubLink =
    "https://github.com/miyamoen/bibliopola"


packageLink : String
packageLink =
    "http://package.elm-lang.org/packages/miyamoen/bibliopola/latest"


twitterLink : String
twitterLink =
    "https://twitter.com/miyamo_madoka"
