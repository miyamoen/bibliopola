UI Catalog for Elm applications built by [elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) inspired by Storybook

* [demo &mdash; Bibliopola on Bibliopola](https://miyamoen.github.io/bibliopola/)
* [package document](http://package.elm-lang.org/packages/miyamoen/bibliopola/latest)

## Features

* UI Catalog that shows `view` functions for development with atomic design.
* Pure Elm tool. Only `elm install miyamoen/bibliopola`.
* Bibliopola make main `Program`, so you can use `elm make` or `elm reactor`, and so on.
* Start to write single Elm file that has `view` finctions.


## How to Use

See [examples](https://github.com/miyamoen/bibliopola/tree/master/examples).

```sh
git clone https://github.com/miyamoen/bibliopola.git
cd bibliopola
elm reactor
```

In browser, open <http://localhost:8000>, then go to `examples` folder.

### Hello, Bibliopola

> `view` that takes no arguments

Open `Hello.elm` file.

![Hello.elm](https://i.gyazo.com/d773e7f21d4b0dd4ec091c11b2925f30.png)

Your `view` function:

```elm
view : Element msg
view =
    text "Hello, Bibliopola"
```

On top left corner, "Hello, Bibliopola" shows up.

First of all, create a `Book`:

```elm
book : Book
book =
    bookWithFrontCover "Hello" view
```

`Book` type requires `view`. `bookWithFrontCover` requires book title such as "Hello" and `view` that has type of `Element`. Bibliopola shows a front cover of book at first.

Now, create main `Program`:

```elm
main : Bibliopola.Program
main =
    fromBook book
```

First Bibliopola has been finished!

> **note:** a word of 'Bibliopola' means a book shop in Latin.

### Hello, your name

> `view` that takes one argument

Open `HelloYou.elm` file.

![HelloYou.elm](https://i.gyazo.com/030facb8ce9160be3a0310c0bf004e55.png)

This book does not specify a front cover, then book icon shows up. To click, you can see "Hello, spam". You can select options with select box at the bottom of the screen.

Your `view` function:

```elm
view : String -> Element msg
view name =
    text <| "Hello, " ++ name
```

It takes one argument, `String`.

```elm
book : Book
book =
    intoBook "HelloYou" identity view -- : IntoBook msg (String -> Element msg)
        |> addStory (Story.build "name" identity [ "spam", "egg", "ham" ]) -- : IntoBook msg (Element msg)
        |> buildBook -- : Book
        -- |> withFrontCover (view "Bibliopola") -- Add first view of Book
```

`IntoBook msg view` type used for building `Book`. First argument of `intoBook`, `String`, is book title. Second argument, `msg -> String`, is for message logger. Last srgument is your `view` function.

In Bibliopola, arguments of `view` is called `Story`. `Story a` type means that Story has list of type `a` and this list is options for argument of `view` function.

At last, `buildBook` turns `IntoBook` to `Book`.
