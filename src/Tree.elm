module Tree exposing
    ( Animations
    , animationsList
    , fadeIn
    , fadeOut
    , init
    , tree
    , update
    )

import Animation as A
import Animation.Spring.Presets as S
import Animations exposing (..)
import Core
import Element.Animated as Animated
import Svg exposing (Svg)
import Svg.Attributes exposing (..)
import Svg.Extra exposing (..)
import Time



-- Animations


type alias Animations =
    List (List A.State)


init =
    [ branches 2
    , branches 3
    , branches 4
    , branches 5
    , branches 6
    ]


branches n =
    List.repeat n hidden


hidden =
    A.style [ A.opacity 0 ]


update aniMsg =
    List.map <| List.map <| A.update aniMsg


animationsList =
    List.concat


fadeIn : Animations -> Animations
fadeIn =
    indexedMap2 fadeWithIndex


fadeOut : Animations -> Animations
fadeOut =
    List.map <| List.map <| A.interrupt [ A.to [ A.opacity 0 ] ]


fadeWithIndex : Int -> A.State -> A.State
fadeWithIndex i el =
    A.interrupt
        [ A.set [ A.opacity 0 ]
        , wait <| 4500 + (i * 100)
        , A.toWith (spring 60 10) [ A.opacity 1 ]
        ]
        el


indexedMap2 : (Int -> a -> b) -> List (List a) -> List (List b)
indexedMap2 f xxs =
    let
        accum xs ( total, acc ) =
            ( total + List.length xs - 1
            , acc ++ [ List.indexedMap (\i x -> f (i + total) x) xs ]
            )
    in
    xxs
        |> List.foldl accum ( 0, [] )
        |> Tuple.second



-- View


tree animations =
    let
        cores =
            List.concat <| List.indexedMap row animations
    in
    Svg.svg
        [ viewBox_ 0 0 537 690
        , width "100%"
        , height "100%"
        ]
        cores


row i animations =
    List.indexedMap (core i) animations


core i j animation =
    let
        spacingX =
            140

        spacingY =
            130

        offsetX =
            -(toFloat i * (spacingX / 2) - 110.5)

        offsetY =
            100
    in
    Animated.g animation [] [ Core.centralCore ]
        |> translated (toFloat j * spacingX + offsetX) (toFloat i * spacingY + offsetY)
        |> scaled 0.6
