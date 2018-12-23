module Layers.Explosion exposing
    ( Animations
    , animationsList
    , explode
    , explosion
    , init
    , update
    )

import Animation as A
import Animations exposing (..)
import Ease
import Element.Animated as Animated
import Layers.Core as Core
import Svg exposing (Svg)
import Svg.Attributes exposing (..)
import Svg.Extra exposing (..)


type alias Animations =
    { location : A.State
    , flicker : A.State
    }


init : Animations
init =
    { location =
        A.style
            [ translateZero
            , A.scale 1
            , A.transformOrigin (A.px 0) (A.px 0) (A.px 0)
            ]
    , flicker = A.style [ A.opacity 0 ]
    }


update : A.Msg -> Animations -> Animations
update msg a =
    { a
        | location = A.update msg a.location
        , flicker = A.update msg a.flicker
    }


animationsList : Animations -> List A.State
animationsList a =
    [ a.flicker
    , a.location
    ]


explode padding a =
    { a
        | location = A.interrupt (downScaleOut padding) a.location
        , flicker =
            A.interrupt
                [ A.repeat 1 hardFlicker
                , wait 200
                , A.repeat 1 hardFlicker
                , wait 500
                , A.repeat 1 hardFlicker
                ]
                a.flicker
    }


downScaleOut padding =
    [ A.set [ A.transformOrigin (A.px <| 267 - padding / 2) (A.px <| 180 - padding / 2) (A.px 0) ]
    , A.to [ A.opacity 1 ]
    , A.toWith (ease 3000 Ease.inOutSine) [ A.translate (A.px 0) (A.px 200) ]
    , A.toWith (ease 1500 Ease.inQuint) [ A.scale 100 ]
    ]


explosion padding animations =
    Svg.svg
        [ viewBox_ -padding -padding (537 + padding) (690 + padding)
        , width "100%"
        , height "100%"
        ]
        [ Animated.g animations.flicker
            [ Animated.g animations.location
                [ Svg.circle
                    [ cx_ <| 267 - padding / 2
                    , cy_ <| 180 - padding / 2
                    , r_ 15
                    , fill "#ed008c"
                    , stroke "#fff"
                    , strokeWidth "2"
                    ]
                    []
                ]
            ]
        ]
