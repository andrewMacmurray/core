module Main exposing (main)

import Animation
import Browser
import Browser.Events exposing (onResize)
import Core
import Html exposing (Attribute, Html, div, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)



-- Program


main : Program Window Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- Model


type alias Model =
    { window : Window
    , coreAnimations : Core.Animations
    }


type Msg
    = StartSequence
    | WindowSize Int Int
    | Animate Animation.Msg


type alias Window =
    { width : Float
    , height : Float
    }



-- Init


init : Window -> ( Model, Cmd Msg )
init window =
    ( initialState window, Cmd.none )


initialState : Window -> Model
initialState window =
    { window = window
    , coreAnimations = Core.init
    }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartSequence ->
            ( { model | coreAnimations = Core.surge model.coreAnimations }, Cmd.none )

        WindowSize width height ->
            ( { model | window = Window (toFloat width) (toFloat height) }
            , Cmd.none
            )

        Animate aniMsg ->
            ( { model | coreAnimations = Core.update aniMsg model.coreAnimations }, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onResize WindowSize
        , Animation.subscription Animate <| Core.animationsList model.coreAnimations
        ]



-- View


view : Model -> Html Msg
view model =
    div
        [ class "w-100"
        , style "background" "#1B1D44"
        , style "padding" "80px"
        , style "height" <| px model.window.height
        , onClick StartSequence
        ]
        [ Core.core model.coreAnimations ]


px : Float -> String
px n =
    String.fromFloat n ++ "px"
