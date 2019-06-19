module Views.Subscriptions exposing (render)

import Entities.Subscription exposing (Subscription)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


render : (String -> Bool -> msg) -> Subscription -> Html msg
render msg sub =
    div [ class "subscription" ]
        [ label [] [ text sub.name ]
        , checkbox msg sub
        ]


checkbox : (String -> Bool -> msg) -> Subscription -> Html msg
checkbox msg sub =
    input
        [ type_ "checkbox"
        , checked sub.subscribed
        , value sub.id
        , onCheck (msg sub.id)
        ]
        []
