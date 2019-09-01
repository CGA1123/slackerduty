module Views.Channels exposing (render)

import Entities.Channel exposing (Channel)
import Html exposing (..)
import Html.Attributes exposing (..)
import Views.Subscriptions


render : (String -> String -> Bool -> msg) -> Channel -> Html msg
render msg channel =
    div [ class "channel" ]
        [ h4 [ class "channel-title" ] [ text channel.id ]
        , renderSubscriptions msg channel
        ]


renderSubscriptions : (String -> String -> Bool -> msg) -> Channel -> Html msg
renderSubscriptions msg channel =
    channel.subscriptions
        |> List.map (Views.Subscriptions.render (msg channel.id))
        |> div [ class "channel-subscriptions subscriptions" ]
