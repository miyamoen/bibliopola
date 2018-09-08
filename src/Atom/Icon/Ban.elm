module Atom.Icon.Ban exposing (Config, view)

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
    """M256,0C114.613,0,0,114.615,0,256s114.613,256,256,256c141.383,0,256-114.615,256-256S397.383,0,256,0z
 M99.594,144.848L367.15,412.406C335.754,434.781,297.402,448,256,448c-105.871,0-192-86.131-192-192
 C64,214.596,77.217,176.244,99.594,144.848z M412.404,367.15L144.848,99.594C176.242,77.219,214.594,64,256,64
 c105.867,0,192,86.131,192,192C448,297.404,434.781,335.756,412.404,367.15z"""
