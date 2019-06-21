module Entities.Incident exposing (Incident, decoder, listDecoder)

import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline


type alias Incident =
    { id : String
    , title : String
    , status : String
    }


decoder : Decode.Decoder Incident
decoder =
    Decode.succeed Incident
        |> Pipeline.required "id" Decode.string
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "status" Decode.string


listDecoder : Decode.Decoder (List Incident)
listDecoder =
    Decode.list decoder
