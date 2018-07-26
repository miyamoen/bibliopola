module List.Extra exposing (lift2)


lift2 : (a -> b -> c) -> List a -> List b -> List c
lift2 f la lb =
    la
        |> List.concatMap
            (\a -> lb |> List.map (\b -> f a b))
