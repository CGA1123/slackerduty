module Views.Channels exposing (render)

import Entities.Channel exposing (Channel)
import Html exposing (..)


render : Channel -> Html msg
render channel =
    text channel.id
