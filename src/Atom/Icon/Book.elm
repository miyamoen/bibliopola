module Atom.Icon.Book exposing (Config, view)

import Atom.Icon as Icon
import Element exposing (..)
import Svg exposing (path)
import Svg.Attributes exposing (d)


type alias Config a msg =
    Icon.Config a msg


view : Icon.Config a msg -> Element msg
view config =
    Icon.view [ path [ d pathString ] [] ] config


pathString : String
pathString =
    """M415.594,93.344l-18.906-62.563c4.625-2.969,7.75-8.156,7.75-14.078C404.438,7.469,396.969,0,387.719,0
 H129.891C112.5,0,96.609,7.094,85.25,18.5c-11.406,11.359-18.516,27.25-18.5,44.625V470.75C66.75,493.531,85.219,512,108,512h302.5
 c19.188,0,34.75-15.547,34.75-34.734V127.578C445.25,110.125,432.344,95.844,415.594,93.344z M129.891,92.844
 c-8.266,0-15.594-3.313-21.016-8.703c-5.406-5.453-8.719-12.766-8.719-21.016s3.313-15.578,8.719-21.016
 c5.422-5.391,12.75-8.703,21.016-8.703h241.984l17.969,59.438H129.891z"""
