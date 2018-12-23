module Main exposing (main)

import Animation
import Animations exposing (hardFlicker)
import Browser
import Browser.Events exposing (onResize)
import Color
import Delay
import Element.Animated as Animated
import Element.Extra exposing (applyIf)
import Html exposing (Attribute, Html, div, p, text)
import Html.Attributes exposing (class, property, style)
import Html.Events exposing (onClick)
import Json.Encode as Encode
import Layers.Backdrop as Backdrop
import Layers.Code as Code
import Layers.Core as Core
import Layers.Explosion as Explosion
import Layers.Tree as Tree
import Style
import Task
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
    , explosionAnimations : Explosion.Animations
    , codeAnimations : Code.Animations
    }


type Msg
    = SurgeCore
    | FadeInTree
    | FadeOutTree
    | FadeInText
    | FlashBackdrop
    | Explode
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
    , explosionAnimations = Explosion.init
    , codeAnimations = Code.init
    }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SurgeCore ->
            ( { model | coreAnimations = Core.surge model.coreAnimations, triggered = True }, queueTreeAndBackdrop )

        FadeInTree ->
            ( { model | treeAnimations = Tree.fadeIn model.treeAnimations }, after 3500 FadeOutTree )

        FadeOutTree ->
            ( { model | treeAnimations = Tree.fadeOut model.treeAnimations }, after 2000 Explode )

        FlashBackdrop ->
            ( { model | backdropAnimations = Backdrop.flash model.backdropAnimations }, Cmd.none )

        Explode ->
            ( { model | explosionAnimations = Explosion.explode (scenePadding model.window) model.explosionAnimations }
            , after 6000 FadeInText
            )

        FadeInText ->
            ( { model | codeAnimations = Code.fadeIn model.codeAnimations }, Cmd.none )

        WindowSize width height ->
            ( updateWindow width height model, Cmd.none )

        Animate aniMsg ->
            ( updateAnimations aniMsg model, Cmd.none )


queueTreeAndBackdrop =
    Cmd.batch
        [ after 4500 FadeInTree
        , after 4000 FlashBackdrop
        ]


updateAnimations : Animation.Msg -> Model -> Model
updateAnimations aniMsg model =
    { model
        | coreAnimations = Core.update aniMsg model.coreAnimations
        , treeAnimations = Tree.update aniMsg model.treeAnimations
        , backdropAnimations = Backdrop.update aniMsg model.backdropAnimations
        , explosionAnimations = Explosion.update aniMsg model.explosionAnimations
        , codeAnimations = Code.update aniMsg model.codeAnimations
    }


updateWindow width height model =
    { model | window = Window (toFloat width) (toFloat height) }


after ms =
    Delay.after ms Delay.Millisecond



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onResize WindowSize
        , Animation.subscription Animate <| allAnimations model
        ]


allAnimations model =
    List.concat
        [ Core.toList model.coreAnimations
        , Tree.toList model.treeAnimations
        , Backdrop.toList model.backdropAnimations
        , Explosion.toList model.explosionAnimations
        , Code.toList model.codeAnimations
        ]



-- View


view : Model -> Html Msg
view model =
    let
        framed =
            sceneContainer (scenePadding model.window) model.window

        fullScreen =
            sceneContainer 0 model.window

        notTriggered =
            not model.triggered
    in
    div
        [ class "w-100 fixed"
        , Style.backgroundColor <| Color.rgb255 27 29 68
        , Style.height model.window.height
        , applyIf notTriggered <| Style.pointer
        , applyIf notTriggered <| onClick SurgeCore
        ]
        [ framed [ Core.core model.coreAnimations ]
        , framed [ Tree.tree model.treeAnimations ]
        , fullScreen [ Explosion.explosion (scenePadding model.window) model.explosionAnimations ]
        , fullScreen [ Backdrop.backdrop model.backdropAnimations ]
        , fullScreen [ Code.code model.window model.codeAnimations ]
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
            80
