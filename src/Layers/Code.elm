module Layers.Code exposing
    ( Animations
    , code
    , fadeIn
    , init
    , list
    , update
    )

import Animation as A
import Animations exposing (..)
import Ease
import Element.Animated as Animated
import Html exposing (div, p, text)
import Html.Attributes exposing (class)
import Layers.Core as Core
import Style


type alias Animations =
    { code : A.State
    , caption1 : A.State
    , caption2 : A.State
    }


init =
    { code = A.style [ A.opacity 0 ]
    , caption1 = A.style [ A.opacity 0 ]
    , caption2 = A.style [ A.opacity 0 ]
    }


update msg a =
    { a
        | code = A.update msg a.code
        , caption1 = A.update msg a.caption1
        , caption2 = A.update msg a.caption2
    }


fadeIn a =
    { a
        | code = A.interrupt hardFlicker a.code
        , caption1 = delayBy 500 hardFlicker a.caption1
        , caption2 = delayBy 700 hardFlicker a.caption2
    }


list a =
    [ a.code
    , a.caption1
    , a.caption2
    ]


code window animations =
    div
        [ Style.height window.height
        , class "w-100 fixed flex flex-column items-center justify-center top-0 left-0"
        ]
        [ Animated.div animations.code [] [ p [ class "white f2 tracked-mega" ] [ text "XVF12938179HJA" ] ]
        , Animated.div animations.caption1 [] [ p [ class "white f7 f5-ns tracked-mega" ] [ text "The Core released an XBOXLIVE code" ] ]
        , Animated.div animations.caption2 [] [ p [ class "white f7 f5-ns tracked-mega ma0" ] [ text "It wishes you a Merry Christmas..." ] ]
        ]
