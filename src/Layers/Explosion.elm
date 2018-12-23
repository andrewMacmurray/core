module Layers.Explosion exposing
    ( Animations
    , explode
    , explosion
    , init
    , toList
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
    , scale : A.State
    , flicker : A.State
    }


init : Animations
init =
    { location = A.style [ translateZero ]
    , scale = A.style [ A.radius 200, A.strokeWidth 10 ]
    , flicker = A.style [ A.opacity 0 ]
    }


update : A.Msg -> Animations -> Animations
update msg a =
    { a
        | location = A.update msg a.location
        , scale = A.update msg a.scale
        , flicker = A.update msg a.flicker
    }


toList : Animations -> List A.State
toList a =
    [ a.flicker
    , a.scale
    , a.location
    ]


explode padding a =
    { a
        | location =
            A.interrupt
                [ wait 800
                , A.toWith (ease 3000 Ease.inOutSine) [ A.translate (A.px 0) (A.px 200) ]
                ]
                a.location
        , scale =
            A.interrupt
                [ A.toWith (ease 800 Ease.inQuint) [ A.radius 15, A.strokeWidth 2 ]
                , wait 3000
                , A.toWith (ease 1500 Ease.inQuint) [ A.radius 2000, A.strokeWidth 120 ]
                ]
                a.scale
        , flicker =
            A.interrupt
                [ A.toWith (ease 800 Ease.inQuart) [ A.opacity 1 ]
                , steps hardFlicker
                , wait 300
                , steps hardFlicker
                , wait 200
                , steps hardFlicker
                ]
                a.flicker
    }


explosion padding animations =
    Svg.svg
        [ viewBox_ -padding -padding (537 + padding) (690 + padding)
        , width "100%"
        , height "100%"
        ]
        [ Animated.g animations.flicker
            [ Animated.g animations.location
                [ Animated.circle animations.scale
                    [ cx_ <| 267 - padding / 2
                    , cy_ <| 180 - padding / 2
                    , fill "#ed008c"
                    , stroke "#fff"
                    ]
                    []
                ]
            ]
        ]
