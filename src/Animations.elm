module Animations exposing
    ( delayBy
    , ease
    , flicker
    , flicker2
    , flickerWithInterval
    , hardFlicker
    , pulse
    , spring
    , steps
    , translateZero
    , wait
    )

import Animation as A
import Animation.Spring.Presets as S
import Ease
import Time


pulse =
    [ A.set [ A.opacity 1, A.scale 1 ]
    , A.toWith (ease 500 <| Ease.bezier 0.25 0.1 0 1.01) [ A.opacity 0, A.scale 2.5 ]
    , wait 1000
    ]


flicker =
    [ A.set [ A.opacity 0 ]
    , A.toWith (ease 800 Ease.inOutElastic) [ A.opacity 0.75 ]
    , A.to [ A.opacity 0 ]
    ]


flicker2 =
    [ A.set [ A.opacity 0 ]
    , A.toWith (ease 800 Ease.inOutBounce) [ A.opacity 0.75 ]
    , A.to [ A.opacity 0 ]
    ]


hardFlicker =
    flickerWithInterval 50


flickerWithInterval interval =
    List.map (\o -> A.toWith (ease interval Ease.linear) [ A.opacity o ])
        [ 0
        , 0.2
        , 0.9
        , 0.5
        , 0.3
        , 0.4
        , 0.8
        , 0.2
        , 0.7
        , 0.3
        , 1
        ]


translateZero =
    A.translate (A.px 0) (A.px 0)


steps =
    A.repeat 1


spring stiffness damping =
    A.spring <| S.Spring stiffness damping


ease duration easing =
    A.easing { duration = duration, ease = easing }


wait =
    A.wait << Time.millisToPosix


delayBy ms animations =
    A.interrupt <| wait ms :: animations
