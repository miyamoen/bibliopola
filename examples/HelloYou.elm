module Hello exposing (book, view)

import Bibliopola exposing (..)
import Bibliopola.Story as Story
import Element exposing (Element, text)


view : String -> Element msg
view name =
    text <| "Hello, " ++ name


book : Book
book =
    intoBook "HelloYou" identity view -- : IntoBook msg (String -> Element msg)
        |> addStory (Story.build "name" identity [ "spam", "egg", "ham" ]) -- : IntoBook msg (Element msg)
        |> buildBook -- : Book
        -- |> withFrontCover (view "Bibliopola") -- Add first view of Book


main : Bibliopola.Program
main =
    fromBook book
