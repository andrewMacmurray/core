module Core exposing (Animations, animationsList, core, init, surge, update)

import Animation as A
import Animation.Spring.Presets as S
import Ease
import Svg exposing (Svg)
import Svg.Animated as Animated
import Svg.Attributes exposing (..)
import Time



-- Animations


type alias Animations =
    { center : A.State
    , pulse : A.State
    , outerLines : A.State
    , whiteLines : A.State
    , pinkLines : A.State
    , blueLines : A.State
    }


init : Animations
init =
    { center = delayBy 500 fadeIn <| A.style [ A.opacity 0 ]
    , pulse = delayBy 1500 [ A.loop pulse ] <| A.style [ A.opacity 0, coreOrigin ]
    , outerLines = A.style [ A.opacity 0 ]
    , whiteLines = A.style [ A.opacity 0 ]
    , pinkLines = A.style [ A.opacity 0 ]
    , blueLines = A.style [ A.opacity 0 ]
    }


coreOrigin : A.Property
coreOrigin =
    A.transformOrigin (A.px 267) (A.px 298) (A.px 0)


update : A.Msg -> Animations -> Animations
update aniMsg a =
    { a
        | pulse = A.update aniMsg a.pulse
        , center = A.update aniMsg a.center
        , outerLines = A.update aniMsg a.outerLines
        , whiteLines = A.update aniMsg a.whiteLines
        , pinkLines = A.update aniMsg a.pinkLines
        , blueLines = A.update aniMsg a.blueLines
    }


animationsList : Animations -> List A.State
animationsList a =
    [ a.pulse
    , a.center
    , a.outerLines
    , a.whiteLines
    , a.pinkLines
    , a.blueLines
    ]


surge : Animations -> Animations
surge a =
    { a
        | outerLines = delayBy 600 fadeInOutSmooth a.outerLines
        , whiteLines = delayBy 200 [ A.repeat 2 flicker ] a.whiteLines
        , pinkLines = delayBy 0 [ A.repeat 2 flicker ] a.pinkLines
        , blueLines = delayBy 500 fadeInOut a.blueLines
    }


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


fadeIn =
    [ A.to [ A.opacity 0 ]
    , A.to [ A.opacity 1 ]
    ]


fadeInOutSmooth =
    let
        spring =
            A.spring S.wobbly
    in
    [ A.toWith spring [ A.opacity 0 ]
    , A.toWith spring [ A.opacity 1 ]
    , A.toWith spring [ A.opacity 0 ]
    ]


fadeInOut =
    [ A.to [ A.opacity 0 ]
    , A.to [ A.opacity 1 ]
    , A.to [ A.opacity 0 ]
    ]


wait =
    A.wait << Time.millisToPosix


delayBy ms steps =
    A.interrupt <| wait ms :: steps


interruptSteps =
    A.interrupt << List.concat



-- View


core : Animations -> Svg msg
core animations =
    Svg.svg
        [ viewBox_ 0 0 537 690
        , width "100%"
        , height "100%"
        ]
        [ Svg.g []
            [ Animated.g animations.outerLines [] [ outerLines ]
            , Animated.g animations.whiteLines [] [ whiteLines ]
            , Animated.g animations.pinkLines [] [ pinkLines ]
            , Animated.g animations.center [] [ centralCore ]
            , Animated.g animations.pulse [] [ centralCore ]
            , Animated.g animations.blueLines [] [ blueLines ]
            ]
        ]


viewBox_ minX minY maxX maxY =
    viewBox <| String.join " " <| List.map String.fromFloat [ minX, minY, maxX, maxY ]


outerLines =
    Svg.g []
        [ Svg.g [ fill "none", stroke "#0f6b7a", strokeWidth "2" ] [ Svg.path [ d "M198.6 42.7L133.8 109M78.2 166.3l-68 65.6" ] [] ]
        , Svg.g [ fill "none", stroke "#0f6b7a", strokeWidth "2" ] [ Svg.path [ d "M528 229.6l-66.2-64.8M404.4 109l-65.5-68" ] [] ]
        , Svg.g [ fill "none", stroke "#0f6b7a", strokeWidth "2" ] [ Svg.path [ d "M343 557.1l64.8-66.2M463.5 433.5l68-65.5" ] [] ]
        , Svg.path [ d "M461.6 371.5v120.4H341.9M78.2 375.8v116.1h117.4M461.5 221.9V108.8l-113.4-.2M269 42.4L12.3 299l255 255L524 297.5l-255-255z", fill "none", stroke "#0f6b7a", strokeWidth "4" ] []
        , Svg.path [ d "M269 32L2 299l265.4 265.4 267-267L269 32z", fill "none", stroke "#0f6b7a", strokeWidth "4" ] []
        , Svg.g []
            [ Svg.path [ fill "none", stroke "#0f6b7a", strokeWidth "4", d "M89.8 134.4h29.3V165H89.8z" ] []
            , Svg.path [ fill "none", stroke "#0f6b7a", strokeWidth "2", d "M88.8 119.1h10.7v10.3H88.8zM108.4 119.1h10.7v10.3h-10.7z" ] []
            , Svg.path [ d "M109.3 124c0-.2-.2-.4-.5-.4H100c-.3 0-.5.2-.5.4v.9c0 .2.2.4.5.4h8.8c.3 0 .5-.2.5-.4v-.9z", fill "#0f6b7a" ] []
            ]
        , Svg.g []
            [ Svg.path [ fill "none", stroke "#0f6b7a", strokeWidth "4", d "M422.8 134.4h29.3V165h-29.3z" ] []
            , Svg.path [ fill "none", stroke "#0f6b7a", strokeWidth "2", d "M421.8 119.1h10.7v10.3h-10.7zM441.4 119.1h10.7v10.3h-10.7z" ] []
            , Svg.path [ d "M442.3 124c0-.2-.2-.4-.5-.4H433c-.3 0-.5.2-.5.4v.9c0 .2.2.4.5.4h8.8c.3 0 .5-.2.5-.4v-.9z", fill "#0f6b7a" ] []
            ]
        , Svg.g []
            [ Svg.path [ fill "none", stroke "#0f6b7a", strokeWidth "4", d "M422.8 435.4h29.3V466h-29.3z" ] []
            , Svg.path [ fill "none", stroke "#0f6b7a", strokeWidth "2", d "M421.8 471.1h10.7v10.3h-10.7zM441.4 471.1h10.7v10.3h-10.7z" ] []
            , Svg.path [ d "M442.3 476.5c0 .2-.2.4-.5.4H433a.4.4 0 0 1-.5-.4v-.9c0-.2.2-.4.5-.4h8.8c.3 0 .5.2.5.4v.9z", fill "#0f6b7a" ] []
            ]
        , Svg.g []
            [ Svg.path [ fill "none", stroke "#0f6b7a", strokeWidth "4", d "M90.2 435.4h29.3V466H90.2z" ] []
            , Svg.path [ fill "none", stroke "#0f6b7a", strokeWidth "2", d "M89.2 471.1h10.7v10.3H89.2zM108.8 471.1h10.7v10.3h-10.7z" ] []
            , Svg.path [ d "M109.7 476.5c0 .2-.2.4-.4.4h-8.9a.4.4 0 0 1-.4-.4v-.9c0-.2.2-.4.4-.4h8.9c.2 0 .4.2.4.4v.9z", fill "#0f6b7a" ] []
            ]
        , Svg.path [ d "M78.3 221.9V108.8l113.5-.2", fill "none", stroke "#0f6b7a", strokeWidth "4" ] []
        , Svg.g [ fill "none", stroke "#0f6b7a", strokeWidth "2" ] [ Svg.path [ d "M12 371.5l66.2 64.8M135.6 492l65.5 68" ] [] ]
        ]


blueLines =
    Svg.g [ fill "none", stroke "#06a9e0", strokeWidth "2" ]
        [ Svg.path [ d "M534.9 273.3l-71.5.2h13.3l-78.6-79-24.5-.2-.4-15.9-105-104.1-51 51-15.3.4.3 28.5M192.9 146.5l.3 22.4-20.6-.2 20.3-22.2zM158.2 173.9h5.8v22.7l-5.5-.2-.3-22.5zM126.8 57.7l-.6 23.5 12.1.6-.2 125.6-59.5 60M2.5 323l76.1.4-23.7-.1 64.2 65 .2-6.3 19 .7V398l15 14.5.2 5.7h4.7l10.1 8.8v30.8l25-.5 37 34.6h10l.1 13.5 8.9 7.9-.8 104.8" ] []
        , Svg.path [ d "M182.9 457.1v48.2l-18.9.2v171.2M248 624.7v23.4M248 654v9.4M248 668.4v4.7M249.3 514.2l18.5 17 49-48.4 9.4-.1.8 206.2M377.6 684.6l-.3-78.2-19.3.5V452.5" ] []
        , Svg.path [ d "M327 482.7l55.8-55.5v-29.4l14.5.4-.2-5.8 5.3.7-.2 51 33-34.8v-55.6M441.7 336v37.6l5.7-6-.3-36" ] []
        ]


pinkLines =
    Svg.g []
        [ Svg.path [ d "M399 298.4h-51M267.4 165.7v43.5M266.9 165L134.7 297 269 431.5 401 299.2 267 164.9z", fill "none", stroke "#ed008c", strokeWidth "4" ] []
        , Svg.path [ d "M230.1 328.7l-18.4.2v282.5M202.8 298l-16.8.1M180 298.1l-45.8-.1M211.7 618.2l-.1 14.3M211.4 638.8v4.4M268 362l.1 27.3M268.5 395.4l-.1 34.8M268.2 446.9l-.4 240.7M268.1 634.5l10.1.1M293.3 353l.2 178.4 24.7-.2M312.3 261.6l36.6-.1.4-196M349.2 142.3h9.3M349 58.2l-.2-19.2M349.3 33.3l-.2-5M268.1 146.5l-.4-112.8h-5.3l.2-20.7h5.7l-.1-11M237.3 205.9l-.2-111-14-.5", fill "none", stroke "#ed008c", strokeWidth "4" ] []
        , Svg.path [ fill "#ed008c", d "M460.8 315.3h4.4v4.6h-4.4zM470.9 315.3h4.4v4.6h-4.4zM480.9 315.3h4.4v4.6h-4.4zM292.9 65.5h4.4v4.6h-4.4zM283.4 65.5h4.4v4.6h-4.4zM273.1 65.5h4.4v4.6h-4.4zM59.8 279.8h4.4v4.6h-4.4zM49.3 280.1h4.4v4.6h-4.4zM39.3 280.1h4.4v4.6h-4.4z" ] []
        , Svg.path [ d "M267.4 215.2v8.7M267.4 230.7v3.7M341.2 298.4h-8.6", fill "none", stroke "#ed008c", strokeWidth "4" ] []
        ]


whiteLines =
    Svg.g []
        [ Svg.g []
            [ Svg.g []
                [ Svg.g []
                    [ Svg.path [ d "M231.4 434.3v8h2.4v-8h-2.4zM226.8 430v12.2h2V430h-2zM222.4 425.2c-.3 0-.5.3-.5.6v15.9c0 .3.2.5.5.5h1c.3 0 .6-.2.6-.5v-16c0-.2-.3-.5-.6-.5h-1z", fill "#fff" ] []
                    , Svg.path [ d "M222.3 424h-26.5 3.2v-9.6h-20.8", fill "none", stroke "#fff", strokeWidth "2" ] []
                    , Svg.path [ d "M205.6 424v5.2h12.2v4.6h-20", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                    , Svg.path [ d "M207.1 409.6H193V399", fill "none", stroke "#fff", strokeWidth "2" ] []
                    , Svg.path [ d "M188.8 399v5.9h-5v-6", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                    , Svg.path [ d "M179 399v10.6h-5.9", fill "none", stroke "#fff", strokeWidth "2" ] []
                    , Svg.path [ d "M180.6 436.4c-.3 0-.5.2-.5.4v.9c0 .2.2.4.5.4h28c.3 0 .5-.2.5-.4v-.9c0-.2-.2-.4-.5-.4h-28z", fill "#fff" ] []
                    , Svg.path [ d "M207.6 433.8c-.3 0-.5.2-.5.5v7.2c0 .3.2.5.5.5h1c.2 0 .5-.2.5-.5v-7.2c0-.3-.3-.5-.5-.5h-1zM180.7 421c-.3 0-.6.2-.6.5v15c0 .4.3.6.6.6h1c.3 0 .5-.2.5-.5v-15.1c0-.3-.2-.5-.5-.5h-1zM175.2 433.8v3h2.1v-3h-2zM175.2 422.2v2.3h2.1v-2.3h-2zM182.8 415v5.2h2v-5.1h-2zM187.9 420.6v4.6h1.9v-4.6h-2zM187.9 415v2.5h1.9V415h-2zM187.9 408.7v1.9h1.9v-1.9h-2zM183 408.7v1.9h1.9v-1.9H183zM173.7 398.8c-.3 0-.5.3-.5.5v6c0 .3.2.6.5.6h1c.3 0 .5-.3.5-.5v-6c0-.3-.2-.6-.5-.6h-1zM173.6 394.1c-.2 0-.4.2-.4.5v.9c0 .2.2.4.4.4h18.9c.2 0 .4-.2.4-.4v-1c0-.2-.2-.4-.4-.4h-18.9zM197.8 400.4v5.5h1.7v-5.5h-1.7zM204.6 418.4v1.9h2.1v-2h-2zM204.6 413.6v1.8h2.1v-1.8h-2zM209.5 418.4v1.9h2v-2h-2zM209.5 412.1v3.6h2.8v-3.6h-2.8zM214.3 416.9v3.4h2.8v-3.4h-2.8zM236 438.8v3.2h2.8v-3.2H236zM214.8 434.2c-.3 0-.5.2-.5.5v6.8c0 .3.2.5.5.5h1.1c.3 0 .6-.2.6-.5v-6.8c0-.3-.3-.5-.6-.5h-1zM202.5 440v2h1.9v-2h-2zM197.7 440v2h1.9v-2h-2zM184.7 440v2h2.3v-2h-2.3zM180.1 440v2h2.4v-2h-2.4zM175.2 440v2h2.1v-2h-2z", fill "#fff" ] []
                    ]
                , Svg.g [ fill "#fff" ]
                    [ Svg.path [ d "M171 373.2v7.6h7.7l-7.7-7.6zM158.6 369.2V388h2v-18.8h-2z" ] []
                    , Svg.path [ d "M157.3 386.4c-.3 0-.5.2-.5.5v1c0 .3.2.6.5.6h2.7c.3 0 .6-.3.6-.6v-1c0-.3-.3-.5-.6-.5h-2.7zM157.3 381.5c-.3 0-.5.2-.5.5v1c0 .3.2.5.5.5h1.8c.2 0 .5-.2.5-.5v-1c0-.3-.3-.5-.5-.5h-1.8zM149.4 381.5v2h4.4v-2h-4.4z" ] []
                    , Svg.path [ d "M149.4 381.5c-.3 0-.5.2-.5.4v6c0 .3.2.6.5.6h1c.2 0 .4-.3.4-.5v-6c0-.3-.2-.5-.5-.5h-1z" ] []
                    , Svg.path [ d "M146.4 386.4v2h4v-2h-4zM144.5 376.7c-.3 0-.5.2-.5.5v1c0 .2.2.4.5.4h3.6c.3 0 .5-.2.5-.5v-1c0-.2-.2-.4-.5-.4h-3.6z" ] []
                    , Svg.path [ d "M144.5 371.8c-.3 0-.5.2-.5.4v6c0 .2.2.4.5.4h1c.2 0 .4-.2.4-.5v-5.9c0-.2-.2-.4-.5-.4h-1z" ] []
                    , Svg.path [ d "M144.8 371.8c-.3 0-.5.2-.5.5v1c0 .2.2.5.5.5h3.3c.3 0 .5-.3.5-.5v-1c0-.3-.2-.5-.5-.5h-3.3zM147 367c-.3 0-.5.2-.5.5v1c0 .2.2.4.4.4h10.8c.3 0 .5-.2.5-.5v-1c0-.2-.2-.4-.5-.4H147z" ] []
                    , Svg.path [ d "M154.2 362c-.3 0-.5.2-.5.5v5.5c0 .2.2.5.5.5h1c.3 0 .5-.3.5-.5v-5.5c0-.3-.2-.5-.5-.5h-1z" ] []
                    , Svg.path [ d "M147.4 362c-.3 0-.5.2-.5.5v1c0 .2.2.4.5.4h10.3c.3 0 .5-.2.5-.5v-1c0-.2-.2-.4-.5-.4h-10.3zM151.7 371.8v2h2v-2h-2zM144.5 357.2v1.9h4.1v-2h-4.1z" ] []
                    , Svg.path [ d "M144.5 352.4c-.3 0-.5.2-.5.4v5.8c0 .3.2.5.5.5h1c.2 0 .4-.2.4-.5v-5.8c0-.2-.2-.4-.5-.4h-1z" ] []
                    , Svg.path [ d "M144.5 352.4v1.9h4.1v-2h-4.1zM139.5 342.3c-.3 0-.5.3-.5.5v6c0 .3.2.6.5.6h1c.3 0 .5-.3.5-.5v-6c0-.3-.2-.6-.5-.6h-1zM137.5 347.3c-.2 0-.4.3-.4.5v6c0 .3.2.5.4.5h1c.3 0 .5-.2.5-.5v-6c0-.2-.2-.5-.5-.5h-1z" ] []
                    , Svg.path [ d "M122.8 352.4c-.2 0-.4.2-.4.5v1c0 .2.2.4.4.4h17.7c.3 0 .5-.2.5-.5v-1c0-.2-.2-.4-.5-.4h-17.7z" ] []
                    , Svg.path [ d "M129.8 347.3c-.3 0-.5.3-.5.6v5.3c0 .2.2.5.5.5h1c.3 0 .5-.3.5-.5v-5.3c0-.3-.2-.6-.5-.6h-1zM124.9 347.3c-.3 0-.5.3-.5.5v5.4c0 .3.2.5.5.5h1c.3 0 .5-.2.5-.5v-5.4c0-.2-.2-.5-.5-.5h-1zM130 340c-.3 0-.6.2-.6.5v1.2c0 .4.3.6.6.6h8.5c.3 0 .6-.2.6-.6v-1.2c0-.3-.3-.6-.6-.6H130z" ] []
                    , Svg.path [ d "M130 332.6c-.3 0-.6.3-.6.5v8.7c0 .3.3.5.5.5h1c.3 0 .6-.2.6-.5v-8.7c0-.2-.3-.5-.5-.5h-1z" ] []
                    , Svg.path [ d "M125 332.6c-.2 0-.4.3-.4.5v1c0 .3.2.5.5.5h5.9c.2 0 .5-.2.5-.5v-1c0-.2-.3-.5-.5-.5h-6z" ] []
                    , Svg.path [ d "M125.2 332.6c-.4 0-.6.3-.6.6v7.9c0 .3.2.6.6.6h1c.4 0 .6-.3.6-.6v-8c0-.2-.2-.5-.5-.5h-1.1z" ] []
                    , Svg.path [ d "M120.1 340v1.7h6.2v-1.8H120zM120 327.9c-.3 0-.5.2-.5.5v1c0 .2.2.5.5.5h6c.3 0 .5-.3.5-.5v-1c0-.3-.2-.5-.5-.5h-6zM137.6 347.3c-.3 0-.5.3-.5.5v1c0 .3.2.6.5.6h2.9c.3 0 .5-.3.5-.6v-1c0-.2-.2-.5-.5-.5h-3z" ] []
                    ]
                ]
            , Svg.g []
                [ Svg.path [ d "M273.6 100.8h-6.3M255.5 108.5h23M285.6 113h-34.8M250.8 118.3l34.8-.1M268.2 105V128M273.6 123.2l-11-.3M254.2 122.9h-10.3v8.3M253.9 127.4v5.8h-5.1v-5.7l39.3-.5v6.3h-5.8v-6.2", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                , Svg.path [ d "M292.6 131.2v-8.3l-10.8.2M292.6 140.7v-6.4M297.3 140.7l-.1-6.4M302.3 140.7l-.1-11.2M307.1 140.7V134M287.5 140.7v-3.3l-10 .1V132M258.5 131.9v5.6l-10-.1.2 3.3", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                , Svg.path [ d "M245.3 141v-7H243v7h2.3zM240.2 141v-7h-2v7h2zM235.3 141v-12h-2v12h2zM230.3 141V134h-1.9v6.8h2zM264.4 102.2v-2h-2.1v2h2zM264.4 108v-3H262v3h2.4zM259.6 108.2V105H257v3.2h2.5zM271.6 106.6V105h-4.2v1.6h4.2zM276.2 108v-3h-1.6v3h1.6zM291.3 119.3V117h-2.5v2.4h2.5zM279.4 124.3v-2.6h-2.7v2.6h2.7zM298.8 126.4v-2.1H296v2h2.8zM298.8 131.1V129H296v2.1h2.8zM315.6 141v-2.3h-2.2v2.3h2.2zM259.6 124.3v-2.6h-2.4v2.6h2.4zM247.2 119.3V117h-1.9v2.4h2zM240 126.4v-2.1h-2.4v2h2.4zM240 131.1V129h-2.4v2.1h2.4z", fill "#fff" ] []
                ]
            , Svg.g []
                [ Svg.g []
                    [ Svg.path [ fill "#fff", d "M118.3 267.4h7.9v2.4h-7.9zM118.3 262.8h12.3v1.9h-12.3zM135.3 258.4c0-.3-.3-.6-.6-.6h-15.9c-.3 0-.5.3-.5.6v1c0 .3.2.6.5.6h16c.2 0 .5-.3.5-.6v-1z" ] []
                    , Svg.path [ d "M136.4 258.3l.1-26.5v3.2h9.6v-20.8", fill "none", stroke "#fff", strokeWidth "2" ] []
                    , Svg.path [ d "M136.4 241.6h-5.1v12.2h-4.6v-20", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                    , Svg.path [ d "M151 243.1l-.1-14.3 10.6.1", fill "none", stroke "#fff", strokeWidth "2" ] []
                    , Svg.path [ d "M161.5 224.8h-5.9v-5h6", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                    , Svg.path [ d "M161.5 215H151v-5.9", fill "none", stroke "#fff", strokeWidth "2" ] []
                    , Svg.path [ d "M124 216.6c0-.3-.1-.5-.3-.5h-.9c-.2 0-.4.2-.4.5v28c0 .3.2.4.4.4h.9c.2 0 .4-.1.4-.4v-28z", fill "#fff" ] []
                    , Svg.path [ d "M126.7 243.6c0-.3-.2-.5-.5-.5H119c-.3 0-.5.2-.5.5v1c0 .2.2.4.5.4h7.2c.3 0 .5-.2.5-.4v-1zM139.5 216.7c0-.3-.2-.6-.5-.6h-15c-.4 0-.6.3-.6.6v1c0 .3.2.5.5.5H139c.3 0 .5-.2.5-.5v-1zM123.6 211.2h3.1v2.1h-3.1zM136 211.2h2.4v2.1H136zM140.3 218.8h5.1v2.1h-5.1zM135.3 223.9h4.6v1.9h-4.6zM143 223.9h2.4v1.9H143zM149.9 223.9h1.8v1.9h-1.8zM149.9 219h1.8v1.9h-1.8zM161.7 209.7c0-.3-.3-.5-.5-.5h-6c-.3 0-.6.2-.6.5v1c0 .3.3.5.5.5h6c.3 0 .6-.2.6-.5v-1zM166.4 209.6c0-.2-.2-.4-.5-.4h-.9c-.2 0-.4.2-.4.4v18.9c0 .2.2.4.4.4h1c.2 0 .4-.2.4-.4v-18.9zM154.6 233.8h5.5v1.7h-5.5zM140.2 240.6h1.9v2.1h-1.9zM145.1 240.6h1.8v2.1h-1.8zM140.2 245.5h1.9v2h-1.9zM144.8 245.5h3.6v2.8h-3.6zM140.2 250.3h3.4v2.8h-3.4zM118.5 271.9h3.3v2.9h-3.3zM126.3 250.8c0-.3-.2-.5-.5-.5H119c-.3 0-.5.2-.5.5v1.1c0 .3.2.6.5.6h6.8c.3 0 .5-.3.5-.6v-1zM118.5 238.5h2v1.9h-2zM118.5 233.7h2v1.9h-2zM118.5 220.7h2v2.3h-2zM118.5 216.1h2v2.4h-2zM118.5 211.2h2v2.1h-2z", fill "#fff" ] []
                    ]
                , Svg.g [ fill "#fff" ]
                    [ Svg.path [ d "M187.3 207h-7.6v7.7l7.6-7.7zM172.5 194.6h18.8v2h-18.8z" ] []
                    , Svg.path [ d "M174.1 193.3c0-.3-.2-.5-.5-.5h-1c-.3 0-.6.2-.6.5v2.7c0 .3.3.6.6.6h1c.3 0 .5-.3.5-.6v-2.7zM179 193.3c0-.3-.2-.5-.5-.5h-1c-.3 0-.5.2-.5.5v1.7c0 .3.2.6.5.6h1c.3 0 .5-.3.5-.6v-1.7zM177 185.4h2.1v4.4H177z" ] []
                    , Svg.path [ d "M179 185.4c0-.3-.2-.5-.4-.5h-6c-.3 0-.6.2-.6.5v1c0 .2.3.4.5.4h6c.3 0 .5-.2.5-.5v-1z" ] []
                    , Svg.path [ d "M172 182.4h2.1v3.9H172zM183.8 180.4c0-.2-.2-.4-.5-.4h-1c-.2 0-.4.2-.4.4v3.7c0 .3.2.5.5.5h1c.2 0 .4-.2.4-.5v-3.7z" ] []
                    , Svg.path [ d "M188.7 180.5c0-.3-.2-.5-.4-.5h-6c-.2 0-.4.2-.4.5v.9c0 .3.2.5.5.5h5.9c.2 0 .4-.2.4-.5v-1z" ] []
                    , Svg.path [ d "M188.7 180.8c0-.3-.2-.5-.5-.5h-1c-.2 0-.5.2-.5.5v3.3c0 .3.3.5.5.5h1c.3 0 .5-.2.5-.5v-3.3zM193.5 183c0-.3-.2-.6-.5-.6h-1c-.2 0-.4.3-.4.5v10.8c0 .3.2.5.5.5h1c.2 0 .4-.2.4-.5V183z" ] []
                    , Svg.path [ d "M198.5 190.2c0-.3-.2-.5-.5-.5h-5.5c-.2 0-.5.2-.5.5v1c0 .3.3.5.5.5h5.5c.3 0 .5-.2.5-.5v-1z" ] []
                    , Svg.path [ d "M198.5 183.4c0-.3-.2-.5-.5-.5h-1c-.2 0-.4.2-.4.5v10.3c0 .3.2.5.5.5h1c.2 0 .4-.2.4-.5v-10.3zM186.7 187.7h2v2h-2zM201.4 180.5h1.9v4.1h-1.9z" ] []
                    , Svg.path [ d "M208.1 180.5c0-.3-.2-.5-.4-.5h-5.8c-.3 0-.5.2-.5.5v1c0 .2.2.4.5.4h5.8c.2 0 .4-.2.4-.5v-1z" ] []
                    , Svg.path [ d "M206.2 180.5h1.9v4.1h-1.9zM218.2 175.5c0-.3-.3-.5-.5-.5h-6c-.3 0-.6.2-.6.5v1c0 .2.3.5.5.5h6c.3 0 .6-.3.6-.5v-1zM213.2 173.5c0-.2-.3-.5-.5-.5h-6c-.3 0-.5.3-.5.5v1c0 .3.2.5.5.5h6c.2 0 .5-.2.5-.5v-1z" ] []
                    , Svg.path [ d "M208.1 158.8c0-.2-.2-.4-.4-.4h-1c-.3 0-.5.2-.5.4v17.7c0 .3.2.5.5.5h1c.2 0 .4-.2.4-.5v-17.7z" ] []
                    , Svg.path [ d "M213.2 165.8c0-.3-.3-.5-.6-.5h-5.3c-.2 0-.5.2-.5.5v1c0 .3.3.5.5.5h5.3c.3 0 .6-.2.6-.5v-1zM213.2 160.9c0-.3-.3-.5-.5-.5h-5.4c-.3 0-.5.2-.5.5v1c0 .3.2.5.5.5h5.4c.2 0 .5-.2.5-.5v-1zM220.6 166c0-.3-.3-.6-.6-.6h-1.2c-.4 0-.6.3-.6.6v8.5c0 .3.2.6.6.6h1.2c.3 0 .6-.3.6-.6V166z" ] []
                    , Svg.path [ d "M227.9 166c0-.4-.3-.6-.5-.6h-8.7c-.3 0-.5.2-.5.5v1c0 .3.2.6.5.6h8.7c.2 0 .5-.3.5-.6v-1z" ] []
                    , Svg.path [ d "M227.9 161c0-.2-.3-.4-.5-.4h-1c-.3 0-.5.2-.5.5v5.9c0 .2.2.5.5.5h1c.2 0 .5-.3.5-.5v-6z" ] []
                    , Svg.path [ d "M227.9 161.1c0-.3-.3-.5-.6-.5h-7.9c-.3 0-.6.2-.6.5v1.2c0 .3.3.5.6.5h8c.2 0 .5-.2.5-.5V161z" ] []
                    , Svg.path [ d "M218.8 156.1h1.7v6.1h-1.7zM232.6 156c0-.3-.2-.5-.5-.5h-1c-.2 0-.5.2-.5.5v6c0 .3.3.5.5.5h1c.3 0 .5-.2.5-.5v-6zM213.2 173.6c0-.3-.3-.6-.5-.6h-1c-.3 0-.6.3-.6.6v2.9c0 .2.3.5.6.5h1c.2 0 .5-.3.5-.5v-3z" ] []
                    ]
                ]
            , Svg.g []
                [ Svg.path [ d "M68.6 292.1v6.3M76.3 310.2v-23M80.7 280.1V315M86 315V280M72.7 297.6h23.1M90.9 292.1l-.2 11M90.6 311.6v10.2H99M95.2 311.9h5.7v5h-5.7l-.4-39.2 6.3-.2v6l-6.2-.1", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                , Svg.path [ d "M98.9 273.2h-8.2V284M108.5 273.2H102M108.5 268.5H102M108.5 263.5H97.2M108.5 258.6h-6.7M108.5 278.3H105l.2 9.9h-5.7M99.6 307.2h5.7l-.2 10 3.4-.1", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                , Svg.path [ fill "#fff", d "M101.7 320.4h7v2.3h-7zM101.7 325.5h7v2.1h-7zM96.7 330.4h12v1.9h-12zM101.9 335.4h6.8v1.9h-6.8zM67.9 301.4H70v2.1h-2.1zM72.8 301.4h2.9v2.3h-2.9zM72.8 306.2H76v2.5h-3.2zM72.7 294.2h1.6v4.2h-1.6zM72.8 289.5h2.9v1.6h-2.9zM84.6 274.4h2.5v2.5h-2.5zM89.5 286.4H92v2.7h-2.5zM92 267h2.1v2.8H92zM96.7 267h2.2v2.8h-2.2zM106.4 250.2h2.3v2.2h-2.3zM89.5 306.1H92v2.5h-2.5zM84.6 318.5h2.5v1.9h-2.5zM92 325.7h2.1v2.4H92zM96.7 325.7h2.2v2.4h-2.2z" ] []
                ]
            , Svg.g []
                [ Svg.g []
                    [ Svg.path [ d "M304.7 162.7v-7.9h-2.3v8h2.3zM309.3 167.1v-12.3h-1.9v12.3h2zM313.8 171.8c.3 0 .5-.2.5-.5v-16c0-.2-.2-.5-.5-.5h-1.1c-.3 0-.5.3-.5.6v15.9c0 .3.2.5.5.5h1z", fill "#fff" ] []
                    , Svg.path [ d "M313.9 173h26.4-3.2l.1 9.7h20.7", fill "none", stroke "#fff", strokeWidth "2" ] []
                    , Svg.path [ d "M330.5 173v-5.1h-12.2v-4.6h20", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                    , Svg.path [ d "M329 187.5h14.3l-.1 10.6", fill "none", stroke "#fff", strokeWidth "2" ] []
                    , Svg.path [ d "M347.3 198l.1-5.8 5-.1v6", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                    , Svg.path [ d "M357.1 198v-10.6h5.9", fill "none", stroke "#fff", strokeWidth "2" ] []
                    , Svg.path [ d "M355.6 160.7c.2 0 .4-.2.4-.5v-.8c0-.3-.2-.4-.4-.4h-28c-.3 0-.5.2-.5.4v.8c0 .3.2.5.4.5h28z", fill "#fff" ] []
                    , Svg.path [ d "M328.5 163.3c.3 0 .5-.2.5-.5v-7.3c0-.2-.2-.4-.5-.4h-1c-.2 0-.4.2-.4.4v7.3c0 .3.2.5.5.5h1zM355.5 176.1c.3 0 .5-.2.5-.5v-15.1c0-.3-.2-.5-.5-.5h-1c-.3 0-.6.2-.6.5v15c0 .4.3.6.5.6h1zM361 163.3v-3h-2.2v3h2.1zM361 175v-2.5h-2.2v2.4h2.1zM353.3 182v-5.1h-2v5h2zM348.3 176.5v-4.6h-2v4.6h2zM348.3 182v-2.4h-2v2.4h2zM348.3 188.3v-1.8h-2v1.8h2zM353.1 188.3v-1.8h-1.9v1.8h2zM362.5 198.2c.2 0 .5-.2.5-.5v-6c0-.3-.3-.5-.5-.5h-1c-.3 0-.6.2-.6.5v6c0 .3.3.5.5.5h1zM362.5 203c.3 0 .5-.3.5-.5v-1c0-.2-.2-.4-.5-.4h-18.8c-.3 0-.5.2-.5.5v.9c0 .3.2.5.5.5h18.8zM338.4 196.7v-5.5h-1.7v5.5h1.7zM331.5 178.7v-1.9h-2v1.9h2zM331.5 183.5v-1.8h-2.1v1.8h2.1zM326.7 178.7v-1.9h-2v1.9h2zM326.7 185v-3.6h-2.9v3.6h2.9zM321.8 180.2v-3.4H319v3.4h2.8zM300.2 158.3V155h-2.9v3.3h3zM321.3 162.9c.3 0 .5-.3.5-.5v-6.8c0-.3-.2-.6-.5-.6h-1c-.4 0-.6.3-.6.6v6.8c0 .2.2.5.5.5h1.1zM333.6 157v-2h-1.8v2h1.8zM338.5 157v-2h-2v2h2zM351.4 157v-2h-2.3v2h2.3zM356 157v-2h-2.4v2h2.4zM361 157v-2h-2.2v2h2.1z", fill "#fff" ] []
                    ]
                , Svg.g [ fill "#fff" ]
                    [ Svg.path [ d "M365.1 223.9v-7.6h-7.6l7.6 7.6zM377.6 227.9V209h-2v18.8h2z" ] []
                    , Svg.path [ d "M378.9 210.7c.2 0 .5-.3.5-.5v-1c0-.3-.3-.6-.5-.6H376c-.3 0-.5.3-.5.5v1c0 .3.2.6.5.6h2.8zM378.9 215.6c.2 0 .5-.2.5-.5v-1c0-.3-.3-.6-.5-.6H377c-.3 0-.5.3-.5.6v1c0 .3.2.5.5.5h1.8zM386.7 215.6v-2h-4.4v2h4.4z" ] []
                    , Svg.path [ d "M386.8 215.6c.3 0 .5-.2.5-.5v-6c0-.3-.2-.5-.5-.5h-1c-.3 0-.5.2-.5.5v6c0 .3.2.5.5.5h1z" ] []
                    , Svg.path [ d "M389.7 210.7v-2h-4v2h4zM391.7 220.4c.2 0 .5-.3.5-.5v-1c0-.2-.3-.4-.5-.4H388c-.3 0-.5.2-.5.4v1c0 .3.2.5.5.5h3.7z" ] []
                    , Svg.path [ d "M391.7 225.3c.2 0 .5-.2.5-.5V219c0-.3-.3-.5-.5-.5h-1c-.2 0-.4.2-.4.5v5.8c0 .3.2.5.4.5h1z" ] []
                    , Svg.path [ d "M391.3 225.3c.3 0 .5-.2.5-.5v-1c0-.3-.2-.5-.5-.5H388c-.2 0-.5.2-.5.5v1c0 .3.3.5.5.5h3.3zM389.2 230c.3 0 .5-.2.5-.4v-1c0-.2-.2-.4-.5-.4h-10.8c-.3 0-.5.2-.5.5v.9c0 .2.2.5.5.5h10.8z" ] []
                    , Svg.path [ d "M382 235c.2 0 .5-.2.5-.4V229c0-.3-.3-.5-.5-.5h-1c-.4 0-.6.2-.6.5v5.5c0 .2.2.5.5.5h1z" ] []
                    , Svg.path [ d "M388.8 235c.2 0 .4-.1.4-.4v-1c0-.2-.2-.4-.4-.4h-10.4c-.3 0-.5.2-.5.5v1c0 .2.2.4.5.4h10.4zM384.5 225.3v-2h-2v2h2zM391.7 239.9v-2h-4.2v2h4.2z" ] []
                    , Svg.path [ d "M391.7 244.7c.2 0 .5-.2.5-.5v-5.7c0-.3-.3-.5-.5-.5h-1c-.2 0-.5.2-.5.5v5.7c0 .3.3.5.5.5h1z" ] []
                    , Svg.path [ d "M391.7 244.7v-2h-4.2v2h4.2zM396.6 254.7c.3 0 .5-.2.5-.4v-6c0-.4-.2-.6-.5-.6h-1c-.2 0-.4.2-.4.5v6c0 .3.2.5.5.5h1zM398.6 249.7c.3 0 .5-.2.5-.5v-6c0-.2-.2-.4-.5-.4h-1c-.3 0-.5.2-.5.5v6c0 .2.2.4.5.4h1z" ] []
                    , Svg.path [ d "M413.3 244.7c.3 0 .5-.2.5-.5v-1c0-.2-.2-.4-.5-.4h-17.7c-.2 0-.4.2-.4.5v1c0 .2.2.4.4.4h17.7z" ] []
                    , Svg.path [ d "M406.4 249.7c.2 0 .5-.2.5-.5V244c0-.3-.3-.5-.5-.5h-1c-.4 0-.6.2-.6.5v5.3c0 .3.2.5.5.5h1zM411.3 249.7c.2 0 .5-.2.5-.5V244c0-.3-.3-.5-.5-.5h-1c-.3 0-.5.2-.5.5v5.3c0 .3.2.5.5.5h1zM406.1 257.2c.3 0 .6-.3.6-.6v-1.2c0-.4-.3-.7-.6-.7h-8.4c-.4 0-.6.3-.6.7v1.2c0 .3.2.6.6.6h8.4z" ] []
                    , Svg.path [ d "M406.2 264.4c.3 0 .5-.2.5-.5v-8.6c0-.3-.2-.6-.5-.6h-1c-.3 0-.5.3-.5.6v8.6c0 .3.2.5.5.5h1z" ] []
                    , Svg.path [ d "M411 264.4c.3 0 .6-.2.6-.5v-1c0-.2-.3-.5-.5-.5h-6c-.2 0-.4.3-.4.5v1c0 .3.2.5.5.5h5.9z" ] []
                    , Svg.path [ d "M411 264.4c.3 0 .6-.2.6-.5v-8c0-.2-.3-.5-.6-.5h-1.1c-.3 0-.6.3-.6.6v7.9c0 .3.3.5.6.5h1z" ] []
                    , Svg.path [ d "M416 257.2v-1.8H410v1.8h6.1zM416.1 269.2c.3 0 .5-.2.5-.5v-1c0-.3-.2-.5-.5-.5h-6c-.3 0-.5.2-.5.5v1c0 .3.2.5.5.5h6zM398.6 249.7c.3 0 .5-.2.5-.5v-1c0-.3-.2-.5-.5-.5h-3c-.2 0-.4.2-.4.5v1c0 .3.2.5.5.5h2.9z" ] []
                    ]
                ]
            , Svg.g []
                [ Svg.path [ d "M273.6 496h-6.3M255.5 488.3h23M285.6 483.8l-34.8.1M250.8 478.5l34.8.2M268.2 491.9v-23.2M273.6 473.7l-11 .2M254.2 474h-10.3v-8.3M253.9 469.4v-5.8h-5.1v5.7l39.3.5v-6.3h-5.8v6.2", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                , Svg.path [ d "M292.6 465.7v8.2l-10.8-.1M292.6 456v6.5M297.3 456l-.1 6.5M302.3 456l-.1 11.3M307.1 456v6.8M287.5 456v3.4l-10-.1v5.6M258.5 465v-5.7l-10 .1.2-3.3", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                , Svg.path [ d "M245.3 455.9v7H243v-7h2.3zM240.2 455.9v7h-2v-7h2zM235.3 455.9v12h-2v-12h2zM230.3 455.9v6.8h-1.9v-6.8h2zM264.4 494.6v2h-2.1v-2h2zM264.4 488.9v2.9H262v-3h2.4zM259.6 488.6v3.2H257v-3.2h2.5zM271.6 490.2v1.6h-4.2v-1.6h4.2zM276.2 488.9v2.9h-1.6v-3h1.6zM291.3 477.5v2.4h-2.5v-2.4h2.5zM279.4 472.5v2.6h-2.7v-2.6h2.7zM298.8 470.4v2.1H296v-2h2.8zM298.8 465.7v2.2H296v-2.2h2.8zM315.6 455.9v2.2h-2.2V456h2.2zM259.6 472.5v2.6h-2.4v-2.6h2.4zM247.2 477.5v2.4h-1.9v-2.4h2zM240 470.4v2.1h-2.4v-2h2.4zM240 465.7v2.2h-2.4v-2.2h2.4z", fill "#fff" ] []
                ]
            , Svg.g []
                [ Svg.path [ d "M466.2 291.6v6.3M458.5 309.7v-23M454 279.6v34.8M448.7 314.4l.1-34.8M462 297H439M443.8 291.6l.2 11M444.1 311v10.3h-8.3M439.5 311.3h-5.7v5.1h5.7l.4-39.2-6.3-.2v5.9h6.3", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                , Svg.path [ d "M435.8 272.7h8.2v10.7M426.2 272.7h6.4M426.2 268h6.4M426.2 263h11.3M426.2 258h6.7M426.2 277.7h3.4l-.2 10h5.7M435.1 306.7h-5.7l.2 10-3.4-.2", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                , Svg.path [ fill "#fff", d "M426 319.9h7v2.3h-7zM426 325h7v2.1h-7zM426 329.9h12v1.9h-12zM426 334.9h6.8v1.9H426zM464.7 300.8h2.1v2.1h-2.1zM459.1 300.8h2.9v2.3h-2.9zM458.7 305.7h3.2v2.5h-3.2zM460.4 293.6h1.6v4.2h-1.6zM459.1 289h2.9v1.6h-2.9zM447.6 273.9h2.5v2.5h-2.5zM442.7 285.8h2.5v2.7h-2.5zM440.6 266.4h2.1v2.8h-2.1zM435.8 266.4h2.2v2.8h-2.2zM426 249.6h2.3v2.2H426zM442.7 305.6h2.5v2.5h-2.5zM447.6 318h2.5v1.9h-2.5zM440.6 325.2h2.1v2.4h-2.1zM435.8 325.2h2.2v2.4h-2.2z" ] []
                ]
            , Svg.g []
                [ Svg.g []
                    [ Svg.path [ fill "#fff", d "M408.7 328h7.9v2.4h-7.9zM404.4 333h12.3v1.9h-12.3zM399.6 339.4c0 .3.3.5.6.5H416c.3 0 .5-.2.5-.5v-1.1c0-.3-.2-.5-.5-.5h-16c-.2 0-.5.2-.5.5v1z" ] []
                    , Svg.path [ d "M398.5 339.5l-.1 26.4v-3.2l-9.6.1v20.7", fill "none", stroke "#fff", strokeWidth "2" ] []
                    , Svg.path [ d "M398.5 356.1h5.1V344h4.6v20", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                    , Svg.path [ d "M384 354.6V369l-10.6-.1", fill "none", stroke "#fff", strokeWidth "2" ] []
                    , Svg.path [ d "M373.4 373h5.9v5h-6", fill "none", stroke "#fff", strokeWidth "2", strokeLinecap "butt" ] []
                    , Svg.path [ d "M373.4 382.7H384v6", fill "none", stroke "#fff", strokeWidth "2" ] []
                    , Svg.path [ d "M410.8 381.2c0 .2.2.4.4.4h.9c.2 0 .4-.2.4-.4v-28c0-.3-.2-.5-.4-.5h-.9c-.2 0-.4.2-.4.4v28z", fill "#fff" ] []
                    , Svg.path [ d "M408.2 354.1c0 .3.2.5.5.5h7.2c.3 0 .5-.2.5-.5v-1c0-.2-.2-.4-.5-.4h-7.2c-.3 0-.5.2-.5.5v1zM395.4 381c0 .4.2.6.5.6h15c.4 0 .6-.2.6-.5v-1c0-.3-.2-.6-.5-.6h-15.1c-.3 0-.5.3-.5.5v1zM408.2 384.4h3.1v2.1h-3.1zM396.6 384.4h2.4v2.1h-2.4zM389.5 376.9h5.1v2.1h-5.1zM395 372h4.6v1.9H395zM389.5 372h2.4v1.9h-2.4zM383.1 372h1.8v1.9h-1.8zM383.1 376.9h1.8v1.9h-1.8zM373.2 388c0 .3.3.6.5.6h6c.3 0 .6-.3.6-.5v-1c0-.3-.3-.6-.5-.6h-6c-.3 0-.6.3-.6.5v1zM368.5 388.1c0 .3.2.5.5.5h.9c.2 0 .4-.2.4-.5v-18.8c0-.3-.2-.5-.4-.5h-1c-.2 0-.4.2-.4.5V388zM374.7 362.3h5.5v1.7h-5.5zM392.8 355h1.9v2.1h-1.9zM388 355h1.8v2.1H388zM392.8 350.3h1.9v2h-1.9zM386.5 349.4h3.6v2.8h-3.6zM391.2 344.6h3.4v2.8h-3.4zM413.2 322.9h3.3v2.9h-3.3zM408.6 346.9c0 .3.2.5.5.5h6.8c.3 0 .5-.2.5-.5v-1c0-.4-.2-.6-.5-.6h-6.8c-.3 0-.5.2-.5.5v1.1zM414.4 357.4h2v1.9h-2zM414.4 362.2h2v1.9h-2zM414.4 374.7h2v2.3h-2zM414.4 379.2h2v2.4h-2zM414.4 384.4h2v2.1h-2z", fill "#fff" ] []
                    ]
                , Svg.g [ fill "#fff" ]
                    [ Svg.path [ d "M347.6 390.7h7.6v-7.6l-7.6 7.6zM343.6 401.2h18.8v2h-18.8z" ] []
                    , Svg.path [ d "M360.8 404.5c0 .2.2.5.5.5h1c.3 0 .6-.3.6-.5v-2.8c0-.3-.3-.5-.6-.5h-1c-.3 0-.5.2-.5.5v2.8zM355.8 404.5c0 .2.3.5.6.5h1c.3 0 .5-.3.5-.5v-1.8c0-.3-.2-.5-.5-.5h-1c-.3 0-.6.2-.6.5v1.8zM355.8 407.9h2.1v4.4h-2.1z" ] []
                    , Svg.path [ d "M355.8 412.4c0 .3.3.5.5.5h6c.3 0 .6-.2.6-.5v-1c0-.3-.3-.5-.5-.5h-6c-.3 0-.6.2-.6.5v1z" ] []
                    , Svg.path [ d "M360.8 411.4h2.1v3.9h-2.1zM351.1 417.3c0 .3.2.5.5.5h1c.2 0 .4-.2.4-.5v-3.7c0-.2-.2-.5-.5-.5h-1c-.2 0-.4.3-.4.5v3.7z" ] []
                    , Svg.path [ d "M346.2 417.3c0 .2.2.5.4.5h6c.2 0 .4-.3.4-.5v-1c0-.2-.2-.4-.5-.4h-5.9c-.2 0-.4.2-.4.4v1z" ] []
                    , Svg.path [ d "M346.2 417c0 .2.2.4.5.4h1c.2 0 .5-.2.5-.5v-3.3c0-.2-.3-.5-.5-.5h-1c-.3 0-.5.3-.5.5v3.3zM341.4 414.8c0 .3.2.5.5.5h1c.2 0 .4-.2.4-.5V404c0-.3-.2-.5-.5-.5h-1c-.2 0-.4.2-.4.5v10.8z" ] []
                    , Svg.path [ d "M336.4 407.6c0 .2.2.5.5.5h5.5c.2 0 .5-.3.5-.5v-1c0-.3-.3-.6-.5-.6h-5.5c-.3 0-.5.3-.5.5v1z" ] []
                    , Svg.path [ d "M336.4 414.4c0 .2.2.4.5.4h1c.2 0 .4-.2.4-.4V404c0-.3-.2-.5-.5-.5h-1c-.2 0-.4.2-.4.5v10.4zM346.2 408.1h2v2h-2zM331.6 413.1h1.9v4.1h-1.9z" ] []
                    , Svg.path [ d "M326.8 417.3c0 .2.2.5.4.5h5.8c.3 0 .5-.3.5-.5v-1c0-.2-.2-.5-.5-.5h-5.8c-.2 0-.4.3-.4.5v1z" ] []
                    , Svg.path [ d "M326.8 413.1h1.9v4.1h-1.9zM316.7 422.3c0 .2.2.4.5.4h6c.3 0 .5-.2.5-.4v-1c0-.3-.2-.5-.4-.5h-6c-.4 0-.6.2-.6.5v1zM321.7 424.2c0 .3.3.5.5.5h6c.3 0 .5-.2.5-.5v-1c0-.2-.2-.5-.5-.5h-6c-.2 0-.5.3-.5.5v1z" ] []
                    , Svg.path [ d "M326.8 438.9c0 .3.2.5.4.5h1c.3 0 .5-.2.5-.5v-17.6c0-.3-.2-.5-.5-.5h-1c-.2 0-.4.2-.4.4V439z" ] []
                    , Svg.path [ d "M321.7 432c0 .2.3.5.6.5h5.3c.2 0 .5-.3.5-.5v-1c0-.4-.3-.6-.5-.6h-5.3c-.3 0-.6.2-.6.5v1zM321.7 436.9c0 .2.3.5.5.5h5.4c.3 0 .5-.3.5-.5v-1c0-.3-.3-.5-.5-.5h-5.4c-.2 0-.5.2-.5.5v1zM314.3 431.7c0 .3.3.6.6.6h1.2c.4 0 .6-.3.6-.6v-8.4c0-.4-.2-.6-.6-.6H315c-.3 0-.6.2-.6.6v8.4z" ] []
                    , Svg.path [ d "M307 431.8c0 .3.3.5.5.5h8.7c.3 0 .5-.2.5-.5v-1c0-.3-.2-.5-.5-.5h-8.7c-.2 0-.5.2-.5.5v1z" ] []
                    , Svg.path [ d "M307 436.7c0 .2.3.5.5.5h1c.3 0 .5-.3.5-.5v-6c0-.2-.2-.4-.5-.4h-1c-.2 0-.5.2-.5.5v5.9z" ] []
                    , Svg.path [ d "M307 436.6c0 .3.3.6.6.6h7.9c.3 0 .6-.3.6-.6v-1.1c0-.3-.3-.6-.6-.6h-8c-.2 0-.5.3-.5.6v1z" ] []
                    , Svg.path [ d "M314.3 435.5h1.7v6.1h-1.7zM302.3 441.7c0 .3.2.5.5.5h1c.2 0 .4-.2.4-.5v-6c0-.3-.2-.5-.4-.5h-1c-.3 0-.5.3-.5.5v6zM321.7 424.2c0 .3.3.5.5.5h1c.3 0 .5-.2.5-.5v-3c0-.2-.2-.4-.5-.4h-1c-.2 0-.5.2-.5.5v2.9z" ] []
                    ]
                ]
            ]
        , Svg.path [ d "M268.5 127.3l-171 171 170.4 170.4 171-171-170.4-170.4z", fill "none", stroke "#fff", strokeWidth "4" ] []
        ]


centralCore =
    Svg.g []
        [ Svg.path [ d "M267.3 252.9L222 298l45.2 45.2 45.3-45.2-45.2-45.2z", fill "#ed008c" ] []
        , Svg.path [ d "M267.2 240l-57.8 57.7 57.7 57.7 57.8-57.7-57.7-57.7z", fill "none", stroke "#fff", strokeWidth "4" ] []
        ]
