module Backdrop exposing
    ( Animations
    , animationsList
    , backdrop
    , flash
    , init
    , update
    )

import Animation as A
import Animations exposing (..)
import Core
import Element.Animated as Animated
import Svg exposing (Svg)
import Svg.Attributes exposing (..)
import Svg.Extra exposing (..)



-- Animations


type alias Animations =
    A.State


init =
    A.style [ A.opacity 0 ]


update =
    A.update


animationsList a =
    [ a ]


flash =
    delayBy 4000
        [ A.repeat 2 flicker2
        ]



-- View


backdrop animations =
    Svg.svg
        [ viewBox_ 0 0 537 690
        , width "100%"
        , height "100%"
        ]
        [ Animated.g animations [] [ Core.pinkLines, Core.whiteLines ] |> translated -325 100 |> scaled 0.75
        , Animated.g animations [] [ Core.pinkLines, Core.whiteLines ] |> translated 520 115 |> scaled 0.75
        ]
