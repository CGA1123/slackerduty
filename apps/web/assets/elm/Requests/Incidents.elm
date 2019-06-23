module Requests.Incidents exposing (get)

import Entities.Incident exposing (Incident, listDecoder)
import Http
import Json.Decode as Decode
import Json.Encode as Encode


get : (Result Http.Error (List Incident) -> msg) -> Cmd msg
get msg =
    Http.get
        { url = "/incidents"
        , expect = Http.expectJson msg listDecoder
        }
