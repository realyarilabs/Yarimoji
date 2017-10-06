module Yarimoji
    exposing
        ( YmojiModel
        , YmojiMsg
        , emojidb
        , initYmojiModel
        , update
        , yariCheckEmoji
        , yariFindEmoji
        , yariMojiTranslate
        , yariMojiTranslateAll
        , yariReplacebyEmoji
        , ymojiPickup
        )

{-| ❤️😺 Simple and light Elm package for emojis 😃❤️.

This package has functions to search for ascii emojis in a string and
replace them with the correspondent unicode.
It also provides an emoji picker for your elm webapp, so you can express yourself properly.
Right now it only contains a few emojis, but more to come in the future.

You can use this package to replace emojis in a string (ascii -> unicode) and/ or
emoji picker if you want:

  - yariFindEmoji, yariMojiTranslate for (string find and replace).
  - use emoji picker like in the example in update function (used for emoji picker).

😎 **Feel free to contribute with this package. We need more tests and more emojis** 😉

The proposal of this package is to add emojis to a web chat opensource made with
Elm and Elixir, promoted by [Yarilabs](http://www.yarilabs.com/).


# Types

@docs YmojiMsg, YmojiModel


# Functions for emoji picker

@docs update, ymojiPickup, initYmojiModel


# Other utils functions

@docs yariMojiTranslate, yariFindEmoji, yariCheckEmoji, yariReplacebyEmoji


# Emoji database

@docs emojidb

-}

import Html exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Json
import Regex as R
import YarimojiStyles exposing (..)


{-| State of the widget
-}
type alias YmojiModel =
    { openWidget : Bool
    }


{-| init a model for state of menu picker
-}
initYmojiModel : YmojiModel
initYmojiModel =
    { openWidget = False
    }


{-| Message for ymoji widget
-}
type YmojiMsg
    = ToggleYmoji


{-| Update function for emoji picker

    import Yarimoji.Yarimoji as Ymoji

    type Msg
        = SetNewMessage String
        | YmojiMsg Ymoji.YmojiMsg
        | NoOp

    type alias Model =
        { newMessage : String
        , ymojiModel : Ymoji.YmojiModel
        }

    initModel : Model
    initModel =
        { newMessage = ""
        , ymojiModel = Ymoji.initYmojiModel
        }


    -- Update

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            YmojiMsg msg ->
                (!) { model | ymojiModel = Ymoji.update msg model.ymojiModel } []


    -- View

    view : Model -> Html Msg
    view model =
        div []
            [ Ymoji.ymojiPickup SetNewMessage YmojiMsg model.ymojiModel
            , input [ onInput SetNewMessage, value model.newMessage ] []
            ]

-}
update : YmojiMsg -> YmojiModel -> YmojiModel
update message ymodel =
    case message of
        ToggleYmoji ->
            { ymodel | openWidget = not ymodel.openWidget }


customOnClick : msg -> Attribute msg
customOnClick message =
    Html.Events.on "click" (Json.succeed message)


{-| A Pickup, pop's a window with all emojis on db for choose. this is a view
of this widget.
-}
ymojiPickup : (String -> msg) -> (YmojiMsg -> msg) -> YmojiModel -> Html msg
ymojiPickup msg ymojiMsg ymodel =
    if ymodel.openWidget then
        let
            mapToHtmlYmoji ( ymoji, key ) =
                span
                    [ customOnClick (msg ymoji)
                    , ymojiIconStyle
                    ]
                    [ text ymoji
                    ]
        in
            span []
                [ span
                    [ widgetBtnToogleStyle
                    ]
                    [ text "😊"
                    ]
                , div
                    [ widgetPickStyle
                    ]
                    [ div
                        [ onClick ToggleYmoji
                        , widgetPickHeaderStyle
                        ]
                        [ text "x"
                        ]
                        |> Html.map ymojiMsg
                    , emojidb
                        |> List.map mapToHtmlYmoji
                        |> div [ ymojiListContainerStyle ]
                    ]
                ]
    else
        span
            [ onClick ToggleYmoji
            , widgetBtnToogleStyle
            ]
            [ text "😊"
            ]
            |> Html.map ymojiMsg


{-| This is for translate from string to emoji fonts

      import Yarimoji as Ymoji

      ymojiTranslateMessage =
          "Hello :D !"
          |> Ymoji.yariFindEmoji
          |> Ymoji.yariMojiTranslate str

      -- output "Hello 😊!"

-}
yariMojiTranslate : String -> List ( String, String ) -> String
yariMojiTranslate stringToTranslate emojidb =
    emojidb
        |> List.head
        |> Maybe.withDefault ( "", "" )
        |> yariReplacebyEmoji stringToTranslate


yariMojiTranslateAll : String -> String
yariMojiTranslateAll string =
    List.foldl (flip yariReplacebyEmoji) string (yariFindEmoji string)


{-| Find emoji on a string

    import Yarimoji as Ymoji

    ymojiFind =
        "Hello :D !"
            |> Ymoji.yariFindEmoji


    -- output [("😊",":D")]

-}
yariFindEmoji : String -> List ( String, String )
yariFindEmoji str =
    emojidb
        |> List.filter
            (\( _, asciiEmoji ) ->
                R.contains (emojiRegex asciiEmoji) str
            )


{-| Replaces all matched keys of emojis on a determinate string
-}
yariReplacebyEmoji : String -> ( String, String ) -> String
yariReplacebyEmoji str ( unicodeEmoji, asciiEmoji ) =
    str
        |> R.replace R.All
            (asciiEmoji |> emojiRegex)
            (\match ->
                let
                    asciiLength =
                        String.length asciiEmoji
                in
                    if String.length match.match == asciiLength then
                        unicodeEmoji
                    else
                        unicodeEmoji ++ String.dropLeft asciiLength match.match
            )


{-| Check if exist any emoji on string

    yariCheckEmoji "some message :D "
    -- returns a bool if any key found on emojidb

-}
yariCheckEmoji : String -> Bool
yariCheckEmoji str =
    emojidb
        |> List.any
            (\( _, asciiEmoji ) -> R.contains (asciiEmoji |> emojiRegex) str)



{- Helper function to padRight to match and replace on user input -}


emojiRegex : String -> R.Regex
emojiRegex str =
    str
        |> R.escape
        |> (\s -> String.append s "($|\\s)")
        |> R.regex


{-| Emoji database list

        -- [ ( "😊", ":)" ), ( "😉", ";)" ), ... ]

-}
emojidb : List ( String, String )
emojidb =
    [ ( "😊", ":)" )
    , ( "😉", ";)" )
    , ( "😟", ":(" )
    , ( "😎", "B)" )
    , ( "😃", ":D" )
    , ( "😩", "D:" )
    , ( "😋", ":d" )
    , ( "😜", ";p" )
    , ( "😛", ":p" )
    , ( "😮", ":o" )
    , ( "😖", ":s" )
    , ( "😶", ":x" )
    , ( "😐", ":|" )
    , ( "😕", ":/" )
    , ( "😳", ":[" )
    , ( "😏", ":>" )
    , ( "😷", ":@" )
    , ( "😘", ":*" )
    , ( "😬", ":!" )
    , ( "😇", "o:)" )
    , ( "😠", ">:-o" )
    , ( "😈", ">:-)" )
    , ( "😺", ":3" )
    , ( "👍", "(y)" )
    , ( "👎", "(n)" )
    , ( "❤️", "<3" )
    ]
