module Svg.Extra exposing
    ( scaled
    , translated
    , viewBox_
    , windowBox
    , x_
    , y_
    )

import Svg
import Svg.Attributes exposing (transform, viewBox, x, y)


windowBox window =
    viewBox_ 0 0 window.width window.height


viewBox_ minX minY maxX maxY =
    viewBox <| String.join " " <| List.map String.fromFloat [ minX, minY, maxX, maxY ]


translated x y el =
    Svg.g [ transform <| translate x y ] [ el ]


scaled n el =
    Svg.g [ transform <| scale n ] [ el ]


x_ =
    x << String.fromFloat


y_ =
    y << String.fromFloat


scale n =
    String.concat [ "scale(", String.fromFloat n, ")" ]


translate x y =
    String.concat [ "translate(", String.fromFloat x, ",", String.fromFloat y, ")" ]
