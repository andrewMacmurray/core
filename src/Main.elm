module Main exposing (main)

import Browser
import Browser.Events exposing (onResize)
import Core
import Html exposing (Attribute, Html, div, text)
import Html.Attributes exposing (class, style)



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
    }


type Msg
    = WindowSize Int Int


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
    { window = window }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowSize width height ->
            ( { model | window = Window (toFloat width) (toFloat height) }
            , Cmd.none
            )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    onResize WindowSize



-- View


view : Model -> Html Msg
view model =
    div
        [ class "w-100"
        , style "background" "#1B1D44"
        , style "padding" "80px"
        , style "height" <| px model.window.height
        ]
        [ Core.core ]


px : Float -> String
px n =
    String.fromFloat n ++ "px"
