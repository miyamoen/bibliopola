module Atom.Index exposing (..)

import Atom.Caret as Caret
import Atom.File as File
import Atom.Folder as Folder
import Bibliopola exposing (..)
import Color.Pallet as Pallet exposing (Pallet(..))
import Styles exposing (styles)
import Types exposing (..)


tree : ViewTree (Styles s) (Variation v)
tree =
    createEmptyViewTree "Atom"
        |> insertViewItem caret
        |> insertViewItem file
        |> insertViewItem folder


caret : ViewItem (Styles s) (Variation v)
caret =
    let
        config pallet =
            { pallet = pallet
            , onClick = Just (\dir -> toString dir ++ " clicked!")
            , size = 256
            }
    in
    createViewItem2 "Caret"
        Caret.view
        ( "pallet"
        , List.map (\p -> toString p => config p) Pallet.pallets
        )
        ( "direction"
        , List.map (\dir -> toString dir => dir) Caret.directions
        )
        |> withDefaultVariation (Caret.view (config Black) Caret.Up)


file : ViewItem (Styles s) (Variation v)
file =
    let
        config pallet =
            { pallet = pallet
            , onClick = Just "File clicked!"
            , size = 256
            }
    in
    createViewItem "File"
        File.view
        ( "pallet"
        , List.map (\p -> toString p => config p) Pallet.pallets
        )
        |> withDefaultVariation (File.view <| config Black)


folder : ViewItem (Styles s) (Variation v)
folder =
    let
        config pallet =
            { pallet = pallet
            , onClick = Just "Folder clicked!"
            , size = 256
            }
    in
    createViewItem "Folder"
        Folder.view
        ( "pallet"
        , List.map (\p -> toString p => config p) Pallet.pallets
        )
        |> withDefaultVariation (Folder.view <| config Black)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewTree styles tree
