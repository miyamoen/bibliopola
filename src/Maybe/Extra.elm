module Maybe.Extra exposing (combine)


traverse : (a -> Maybe b) -> List a -> Maybe (List b)
traverse f =
    let
        step e acc =
            case f e of
                Nothing ->
                    Nothing

                Just x ->
                    Maybe.map ((::) x) acc
    in
    List.foldr step (Just [])


combine : List (Maybe a) -> Maybe (List a)
combine =
    traverse identity
