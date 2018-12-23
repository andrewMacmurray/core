module Element.Animated exposing
    ( circle
    , div
    , g
    )

import Animation
import Html exposing (Html)
import Svg


div animated =
    Html.div <| Animation.render animated


g animated =
    Svg.g <| Animation.render animated


circle animated attrs =
    Svg.circle <|
        List.concat
            [ Animation.render animated
            , attrs
            ]
