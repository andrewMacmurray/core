module Animations exposing
    ( delayBy
    , flicker
    , flicker2
    , pulse
    , spring
    , wait
    )

import Animation as A
import Animation.Spring.Presets as S
import Ease
import Time


pulse =
    [ A.set [ A.opacity 1, A.scale 1 ]
    , A.toWith (A.easing { duration = 500, ease = Ease.bezier 0.25 0.1 0 1.01 }) [ A.opacity 0, A.scale 2.5 ]
    , wait 1000
    ]


flicker =
    [ A.set [ A.opacity 0 ]
    , A.toWith (A.easing { duration = 800, ease = Ease.inOutElastic }) [ A.opacity 0.75 ]
    , A.to [ A.opacity 0 ]
    ]


flicker2 =
    [ A.set [ A.opacity 0 ]
    , A.toWith (A.easing { duration = 800, ease = Ease.inOutBounce }) [ A.opacity 0.75 ]
    , A.to [ A.opacity 0 ]
    ]


spring stiffness damping =
    A.spring <| S.Spring stiffness damping


wait =
    A.wait << Time.millisToPosix


delayBy ms steps =
    A.interrupt <| wait ms :: steps
