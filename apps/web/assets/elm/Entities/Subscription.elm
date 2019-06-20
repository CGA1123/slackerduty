module Entities.Subscription exposing (Subscription, decoder, listDecoder)

import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline


type alias Subscription =
    { id : String
    , name : String
    , subscribed : Bool
    }


decoder : Decode.Decoder Subscription
decoder =
    Decode.succeed Subscription
        |> Pipeline.required "id" Decode.string
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "subscribed" Decode.bool


listDecoder : Decode.Decoder (List Subscription)
listDecoder =
    Decode.list decoder
