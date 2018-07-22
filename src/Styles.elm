module Styles exposing (..)

import Color.Pallet as Pallet exposing (pallets)
import Style exposing (..)
import Style.Border as Border
import Style.Color as Color
import Style.Font as Font
import Style.Sheet as Sheet
import Types exposing (..)


styleSheet :
    List (Style child childVar)
    -> StyleSheet (Styles child) (Variation childVar)
styleSheet child =
    Style.styleSheet <|
        (Sheet.merge <| Sheet.map Child ChildVar child)
            :: styles


styles : List (Style (Styles child) (Variation childVar))
styles =
    [ style None []
    , style Text ([ Font.size 20 ] ++ textPalletVars)
    , style Box ([ Border.rounded 5 ] ++ backgroundPalletVars)
    ]


textPalletVars : List (Property class (Variation childVar))
textPalletVars =
    List.map
        (\pallet ->
            variation (PalletVar pallet)
                [ Color.text <| Pallet.color pallet ]
        )
        pallets


backgroundPalletVars : List (Property class (Variation childVar))
backgroundPalletVars =
    List.map
        (\pallet ->
            variation (PalletVar pallet)
                [ Color.background <| Pallet.color pallet ]
        )
        pallets
