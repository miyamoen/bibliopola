module Main exposing (shelf)

import Atom.Index
import Bibliopola exposing (..)
import Element exposing (Element)
import Element.Font as Font
import Molecule.Index
import Organism.Index
import Page.Index


frontMatter : Element String
frontMatter =
    Element.el
        [ Element.width Element.fill
        , Element.height Element.fill
        ]
    <|
        Element.column
            [ Element.width Element.fill
            , Element.centerY
            , Element.spacing 10
            ]
            [ Element.el [ Font.size 24, Element.centerX ] (Element.text "Welcome to Bibliopola")
            , Element.textColumn [ Font.center, Element.centerX ]
                [ Element.paragraph []
                    [ Element.text "Use the tree view in the left side to explore the components."
                    ]
                , Element.paragraph []
                    [ Element.text "You can also go see its "
                    , Element.link [ Font.color <| Element.rgb255 40 40 100 ]
                        { url = "https://github.com/miyamoen/bibliopola"
                        , label = Element.text "source code"
                        }
                    , Element.text ", and read its "
                    , Element.link
                        [ Font.color <| Element.rgb255 40 40 100 ]
                        { url = "http://package.elm-lang.org/packages/miyamoen/bibliopola/latest"
                        , label = Element.text "documentation"
                        }
                    ]
                ]
            ]


main : Bibliopola.Program
main =
    customProgram
        { title = "Bibliopola components"
        , front =
            Just
                frontMatter
        }
        shelf


shelf : Shelf
shelf =
    emptyShelf "Bibliopola"
        |> addShelf Atom.Index.shelf
        |> addShelf Molecule.Index.shelf
        |> addShelf Organism.Index.shelf
        |> addShelf Page.Index.shelf
