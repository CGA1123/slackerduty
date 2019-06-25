module Requests.Channels exposing (get)

import Entities.Channel exposing (Channel, listDecoder)
import Http
import Json.Decode as Decode
import Json.Encode as Encode


get : (Result Http.Error (List Channel) -> msg) -> Cmd msg
get msg =
    Http.get
        { url = "/channels"
        , expect = Http.expectJson msg listDecoder
        }


update : String -> (Result Http.Error (List String) -> msg) -> String -> Bool -> Cmd msg
update token msg id selection =
    let
        body =
            Encode.object
                [ ( "id", Encode.string id )
                , ( "subscribe", Encode.bool selection )
                , ( "_csrf_token", Encode.string token )
                ]
    in
    Http.request
        { method = "PATCH"
        , url = "/channels"
        , headers = []
        , timeout = Nothing
        , tracker = Nothing
        , expect = Http.expectJson msg (Decode.list Decode.string)
        , body = Http.jsonBody body
        }
