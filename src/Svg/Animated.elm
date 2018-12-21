module Svg.Animated exposing (g)

import Animation
import Svg


g animatedStyle attrs =
    Svg.g <|
        List.concat
            [ Animation.render animatedStyle
            , attrs
            ]
