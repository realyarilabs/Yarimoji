module YarimojiTest exposing (..)

import Char
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Tuple
import Yarimoji
    exposing
        ( emojidb
        , yariCheckEmoji
        , yariFindEmoji
        , yariMojiTranslate
        , yariMojiTranslateAll
        )


-- , initYmojiModel
-- , update
-- , yariMojiTranslate
-- , yariReplacebyEmoji
-- , ymojiPickup


emojiDBTest : Test
emojiDBTest =
    describe "EmojiDBTest"
        [ test "EmojiDB maps from chars that are ascii" <|
            \() ->
                List.map Tuple.second emojidb
                    |> String.concat
                    |> String.toList
                    |> List.map Char.toCode
                    |> List.all (\c -> c < 128)
                    |> Expect.true "All emoji come from ascii"
        , test "EmojiDB mas to chars that are not! ascii" <|
            \() ->
                List.map Tuple.first emojidb
                    |> String.concat
                    |> String.toList
                    |> List.map Char.toCode
                    |> List.all (\c -> c > 128)
                    |> Expect.true "No emoji has ascii"
        ]


containsEmojiTest : Test
containsEmojiTest =
    describe "ContainsEmojiTest"
        [ test "emoji in string" <|
            \() ->
                "Hello guys :D"
                    |> yariCheckEmoji
                    |> Expect.true "expect emoji to be found"
        , test "many emoji in string" <|
            \() ->
                "This string :) is the best string :p . >:-o"
                    |> yariCheckEmoji
                    |> Expect.true "expect emoji to be found"
        , test "emoji followed by exclamation point" <|
            \() ->
                "Things:p!"
                    |> yariCheckEmoji
                    |> Expect.false "expect emoji not to be found"
        , test "url, has unwanted emoji after protocol" <|
            \() ->
                "http://www.google.com"
                    |> yariCheckEmoji
                    |> Expect.false "expect emoji not to be found"
        ]


findEmojiTest : Test
findEmojiTest =
    describe "FindEmojiTest"
        [ test "emoji in string" <|
            \() ->
                "Hello guys :D"
                    |> yariFindEmoji
                    |> List.head
                    |> Maybe.map Tuple.second
                    |> Expect.equal (Just ":D")
        , test "many emoji in string" <|
            \() ->
                "This string :) is the best string :p . >:-o"
                    |> yariFindEmoji
                    |> List.map Tuple.second
                    |> Expect.equalLists [ ":)", ":p", ">:-o" ]
        , test "emoji followed by exclamation point" <|
            \() ->
                "Things:p!"
                    |> yariFindEmoji
                    |> List.map Tuple.second
                    |> Expect.equalLists []
        , test "url, has unwanted emoji after protocol" <|
            \() ->
                "http://www.google.com"
                    |> yariFindEmoji
                    |> List.map Tuple.second
                    |> Expect.equalLists []
        ]


translateEmojiTest : Test
translateEmojiTest =
    describe "TranslateEmojiTest"
        [ test "emoji in string" <|
            \() ->
                "Hello guys :D"
                    |> yariMojiTranslateAll
                    |> Expect.equal "Hello guys 😃"
        , test "many emoji in string" <|
            \() ->
                "This string :) is the best string :p . >:-o"
                    |> yariMojiTranslateAll
                    |> Expect.equal "This string 😊 is the best string 😛 . 😠"
        , test "emoji followed by exclamation point" <|
            \() ->
                "Things:p!"
                    |> yariMojiTranslateAll
                    |> Expect.equal "Things:p!"
        , test "url, has unwanted emoji after protocol" <|
            \() ->
                "http://www.google.com"
                    |> yariMojiTranslateAll
                    |> Expect.equal "http://www.google.com"
        ]
