module Window exposing (Width(..), Window, width)


type alias Window =
    { width : Float
    , height : Float
    }


type Width
    = Wide
    | Narrow


width : Window -> Width
width window =
    if window.width <= 480 then
        Narrow

    else
        Wide
