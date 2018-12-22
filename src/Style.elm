module Style exposing
    ( backgroundColor
    , height
    , marginTop
    , padding
    , width
    )

import Color
import Html.Attributes exposing (style)


width =
    style "width" << px


height =
    style "height" << px


padding =
    style "padding" << px


marginTop =
    style "margin-top" << px


backgroundColor =
    style "background-color" << Color.toCssString


px : Float -> String
px n =
    String.fromFloat n ++ "px"
