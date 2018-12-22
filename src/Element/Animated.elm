module Element.Animated exposing
    ( div
    , g
    )

import Animation
import Html exposing (Html)
import Svg


div animatedStyle attrs =
    Html.div <|
        List.concat
            [ Animation.render animatedStyle
            , attrs
            ]


g animatedStyle attrs =
    Svg.g <|
        List.concat
            [ Animation.render animatedStyle
            , attrs
            ]
