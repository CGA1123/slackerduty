module Requests.Subscriptions exposing (get, update)

import Entities.Subscription exposing (Subscription, listDecoder)
import Http
import Json.Decode as Decode
import Json.Encode as Encode


get : (Result Http.Error (List Subscription) -> msg) -> Cmd msg
get msg =
    Http.get
        { url = "/subscriptions"
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
        , url = "/subscriptions"
        , headers = []
        , timeout = Nothing
        , tracker = Nothing
        , expect = Http.expectJson msg (Decode.list Decode.string)
        , body = Http.jsonBody body
        }
