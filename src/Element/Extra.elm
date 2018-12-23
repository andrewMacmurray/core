module Element.Extra exposing (applyIf)

import Json.Encode as Encode
import VirtualDom exposing (property)


applyIf predicate attr =
    if predicate then
        attr

    else
        property "" <| Encode.string ""
