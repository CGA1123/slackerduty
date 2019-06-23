module Entities.Incident exposing (Incident, decoder, listDecoder)

import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline


type Alert
    = Honeycomb { title : String, description : String, url : String }
    | Bugsnag { title : String, stackTrace : String, url : String }
    | Unknown


type alias Incident =
    { id : String
    , title : String
    , status : String
    , url : String
    , service : String
    , alert : Alert
    }


decoder : Decode.Decoder Incident
decoder =
    Decode.succeed Incident
        |> Pipeline.required "id" Decode.string
        |> Pipeline.required "title" Decode.string
        |> Pipeline.required "status" Decode.string
        |> Pipeline.required "html_url" Decode.string
        |> Pipeline.required "service_summary" Decode.string
        |> Pipeline.required "alert" alertDecoder


listDecoder : Decode.Decoder (List Incident)
listDecoder =
    Decode.list decoder


alertDecoder : Decode.Decoder Alert
alertDecoder =
    Decode.at [ "body", "cef_details", "client" ] Decode.string
        |> Decode.andThen decodeAlert


decodeAlert : String -> Decode.Decoder Alert
decodeAlert client =
    case client of
        "Honeycomb Triggers" ->
            Decode.succeed (\x y z -> Honeycomb { title = x, description = y, url = z })
                |> Pipeline.optionalAt [ "body", "cef_details", "details", "trigger_description" ] Decode.string ""
                |> Pipeline.requiredAt [ "body", "cef_details", "details", "description" ] Decode.string
                |> Pipeline.requiredAt [ "body", "cef_details", "client_url" ] Decode.string

        "Bugsnag" ->
            Decode.succeed (\x y z -> Bugsnag { title = x, stackTrace = y, url = z })
                |> Pipeline.requiredAt [ "body", "cef_details", "details", "class" ] Decode.string
                |> Pipeline.requiredAt [ "body", "cef_details", "details", "stackTrace" ] Decode.string
                |> Pipeline.requiredAt [ "body", "cef_details", "client_url" ] Decode.string

        _ ->
            Decode.succeed Unknown
