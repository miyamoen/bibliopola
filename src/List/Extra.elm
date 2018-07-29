module List.Extra exposing (lift2, lift3, lift4)

import List exposing (..)


lift2 : (a -> b -> c) -> List a -> List b -> List c
lift2 f la lb =
    la |> concatMap (\a -> lb |> map (\b -> f a b))


lift3 : (a -> b -> c -> d) -> List a -> List b -> List c -> List d
lift3 f la lb lc =
    la |> concatMap (\a -> lb |> concatMap (\b -> lc |> map (\c -> f a b c)))


lift4 : (a -> b -> c -> d -> e) -> List a -> List b -> List c -> List d -> List e
lift4 f la lb lc ld =
    la
        |> concatMap
            (\a ->
                lb
                    |> concatMap
                        (\b ->
                            lc
                                |> concatMap
                                    (\c -> ld |> map (\d -> f a b c d))
                        )
            )
