module YarimojiStyles exposing (..)

{-| Styles Attributes for yarimoji picker

#Style Attributes

-}

import Html exposing (Attribute)
import Html.Attributes exposing (style)


widgetPickStyle : Attribute msg
widgetPickStyle =
    Html.Attributes.style
        [ ( "position", "absolute" )
        , ( "bottom", "50px" )
        , ( "left", "2px" )
        , ( "backgroundColor", "white" )
        , ( "font-size", "2.5em" )
        , ( "max-height", "200px" )
        , ( "max-width", "200px" )
        , ( "padding", "16px" )
        , ( "margin", "10px" )
        , ( "border-radius", "12px" )
        , ( "border", "1 solid black" )
        , ( "color", "black" )
        , ( "z-index", "9999" )
        ]


widgetPickHeaderStyle : Attribute msg
widgetPickHeaderStyle =
    Html.Attributes.style
        [ ( "height", "1em" )
        , ( "padding", "5px" )
        , ( "padding-right", "10px" )
        , ( "font-size", "1em" )
        , ( "font-height", "2px" )
        , ( "font-weight", "bold" )
        , ( "color", "black" )
        , ( "text-align", "right" )
        , ( "backgroundColor", "gold" )
        , ( "border-top-left-radius", "15px" )
        , ( "border-top-right-radius", "15px" )
        ]


ymojiIconStyle : Attribute msg
ymojiIconStyle =
    Html.Attributes.style
        [ ( "padding", "5px" )
        , ( "cursor", "pointer" )
        ]


ymojiListContainerStyle : Attribute msg
ymojiListContainerStyle =
    Html.Attributes.style
        [ ( "display", "flex" )
        , ( "flex-direction", "row" )
        , ( "flex-flow", "row wrap" )
        , ( "align-items", "stretch" )
        , ( "justify-content", "space-around" )
        , ( "overflow", "hidden" )
        , ( "overflowY", "auto" )
        , ( "max-height", "200px" )
        , ( "padding-top", "10px" )
        , ( "margin", "auto" )
        , ( "backgroundColor", "#eee" )
        ]


widgeBtnTogStyle : Attribute msg
widgeBtnTogStyle =
    Html.Attributes.style
        [ ( "font-size", "2em" )
        , ( "margin-top", "auto" )
        , ( "margin-bottom", "auto" )
        , ( "border-radius", "5px" )
        , ( "border", "1px solid #eee" )
        ]
