module Main exposing (main)

import Browser
import Html exposing (Html)


type alias Model =
    {}


type alias Flags =
    {}


type Msg
    = NoOp


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( {}, Cmd.none )


view : Model -> Html Msg
view model =
    Html.text "hello, world"


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
