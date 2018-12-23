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


g animatedStyle =
    Svg.g <| Animation.render animatedStyle
