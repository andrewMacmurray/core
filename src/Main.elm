module Main exposing (main)

import Animation exposing (left)
import Backdrop
import Browser
import Browser.Events exposing (onResize)
import Color
import Core
import Html exposing (Attribute, Html, div, text)
import Html.Attributes exposing (class, property, style)
import Html.Events exposing (onClick)
import Json.Encode as Encode
import Style
import Task
import Tree
import Window exposing (Window)



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
    , triggered : Bool
    , coreAnimations : Core.Animations
    , treeAnimations : Tree.Animations
    , backdropAnimations : Backdrop.Animations
    }


type Msg
    = SurgeCore
    | FadeInTree
    | FlashBackdrop
    | WindowSize Int Int
    | Animate Animation.Msg



-- Init


init : Window -> ( Model, Cmd Msg )
init window =
    ( initialState window, Cmd.none )


initialState : Window -> Model
initialState window =
    { window = window
    , triggered = False
    , coreAnimations = Core.init
    , treeAnimations = Tree.init
    , backdropAnimations = Backdrop.init
    }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SurgeCore ->
            ( { model | coreAnimations = Core.surge model.coreAnimations, triggered = True }, trigger FadeInTree )

        FadeInTree ->
            ( { model | treeAnimations = Tree.fadeIn model.treeAnimations }, trigger FlashBackdrop )

        FlashBackdrop ->
            ( { model | backdropAnimations = Backdrop.flash model.backdropAnimations }, Cmd.none )

        WindowSize width height ->
            ( { model | window = Window (toFloat width) (toFloat height) }
            , Cmd.none
            )

        Animate aniMsg ->
            ( updateAnimations aniMsg model, Cmd.none )


updateAnimations : Animation.Msg -> Model -> Model
updateAnimations aniMsg model =
    { model
        | coreAnimations = Core.update aniMsg model.coreAnimations
        , treeAnimations = Tree.update aniMsg model.treeAnimations
        , backdropAnimations = Backdrop.update aniMsg model.backdropAnimations
    }


trigger : msg -> Cmd msg
trigger msg =
    Task.succeed msg |> Task.perform identity



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onResize WindowSize
        , subscribeAnimations model
        ]


subscribeAnimations model =
    [ Core.animationsList model.coreAnimations
    , Tree.animationsList model.treeAnimations
    , Backdrop.animationsList model.backdropAnimations
    ]
        |> List.concat
        |> Animation.subscription Animate



-- View


view : Model -> Html Msg
view model =
    let
        framed =
            sceneContainer (scenePadding model.window) model.window
    in
    div
        [ class "w-100 fixed"
        , Style.backgroundColor <| Color.rgb255 27 29 68
        , Style.height model.window.height
        , applyIf (not model.triggered) <| onClick SurgeCore
        ]
        [ framed [ Core.core model.coreAnimations ]
        , framed [ Tree.tree model.treeAnimations ]
        , sceneContainer 0 model.window [ Backdrop.backdrop model.backdropAnimations ]
        ]


sceneContainer padding window =
    div
        [ class "fixed w-100 top-0 left-0"
        , Style.height window.height
        , Style.padding padding
        ]


scenePadding window =
    case Window.width window of
        Window.Narrow ->
            30

        Window.Wide ->
            150


applyIf predicate attr =
    if predicate then
        attr

    else
        property "" <| Encode.string ""
