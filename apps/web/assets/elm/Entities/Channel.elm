module Entities.Channel exposing (Channel, decoder, listDecoder)

import Entities.Subscription as Subscription exposing (Subscription)
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline


type alias Channel =
    { id : String
    , name : String
    , subscriptions : List Subscription
    }


decoder : Decode.Decoder Channel
decoder =
    Decode.succeed Channel
        |> Pipeline.required "id" Decode.string
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "subscriptions" Subscription.listDecoder


listDecoder : Decode.Decoder (List Channel)
listDecoder =
    Decode.list decoder
