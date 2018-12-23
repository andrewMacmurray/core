module Svg.Extra exposing
    ( cx_
    , cy_
    , r_
    , scaled
    , translated
    , viewBox_
    , windowBox
    )

import Svg
import Svg.Attributes exposing (..)


windowBox window =
    viewBox_ 0 0 window.width window.height


viewBox_ minX minY maxX maxY =
    viewBox <| String.join " " <| List.map String.fromFloat [ minX, minY, maxX, maxY ]


translated x y el =
    Svg.g [ transform <| translate x y ] [ el ]


scaled n el =
    Svg.g [ transform <| scale n ] [ el ]


cx_ =
    cx << String.fromFloat


cy_ =
    cy << String.fromFloat


r_ =
    r << String.fromFloat


scale n =
    String.concat [ "scale(", String.fromFloat n, ")" ]


translate x y =
    String.concat [ "translate(", String.fromFloat x, ",", String.fromFloat y, ")" ]
