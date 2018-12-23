module Layers.Backdrop exposing
    ( Animations
    , animationsList
    , backdrop
    , flash
    , init
    , update
    )

import Animation as A
import Animations exposing (..)
import Element.Animated as Animated
import Layers.Core as Core
import Svg exposing (Svg)
import Svg.Attributes exposing (..)
import Svg.Extra exposing (..)



-- Animations


type alias Animations =
    { whitePink1 : A.State
    , whitePink2 : A.State
    , blue1 : A.State
    , blue2 : A.State
    }


init =
    { whitePink1 = A.style [ A.opacity 0 ]
    , whitePink2 = A.style [ A.opacity 0 ]
    , blue1 = A.style [ A.opacity 0 ]
    , blue2 = A.style [ A.opacity 0 ]
    }


update msg a =
    { a
        | whitePink1 = A.update msg a.whitePink1
        , whitePink2 = A.update msg a.whitePink2
        , blue1 = A.update msg a.blue1
        , blue2 = A.update msg a.blue2
    }


animationsList a =
    [ a.whitePink1
    , a.whitePink2
    , a.blue1
    , a.blue2
    ]


flash a =
    { a
        | whitePink1 = A.interrupt [ A.repeat 2 flicker2 ] a.whitePink1
        , whitePink2 = delayBy 100 [ A.repeat 2 flicker2 ] a.whitePink2
        , blue1 = delayBy 3000 [ A.repeat 1 <| flickerWithInterval 5, A.to [ A.opacity 0 ] ] a.blue1
        , blue2 = delayBy 3200 [ A.repeat 1 <| flickerWithInterval 5, A.to [ A.opacity 0 ] ] a.blue2
    }



-- View


backdrop animations =
    Svg.svg
        [ Core.frame
        , width "100%"
        , height "100%"
        ]
        [ Animated.g animations.whitePink1 [ Core.pinkLines, Core.whiteLines ] |> translated -325 100 |> scaled 0.75
        , Animated.g animations.blue1 [ Core.blueLines ] |> translated -325 205 |> scaled 0.6
        , Animated.g animations.whitePink2 [ Core.pinkLines, Core.whiteLines ] |> translated 520 115 |> scaled 0.75
        , Animated.g animations.blue2 [ Core.blueLines ] |> translated 700 195 |> scaled 0.6
        ]
