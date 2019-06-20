module Main exposing (main)

import Browser
import Entities.Subscription exposing (Subscription)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Requests.Subscriptions
import Views.Subscriptions


type alias Model =
    { subscriptions : Maybe (List Subscription)
    , csrfToken : String
    }


type alias Flags =
    { csrfToken : String }


type Msg
    = NoOp
    | SubscriptionUpdated (Result Http.Error (List String))
    | SubscriptionChange String Bool
    | GotSubscriptions (Result Http.Error (List Subscription))


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { subscriptions = Nothing
            , csrfToken = flags.csrfToken
            }
    in
    ( model, Requests.Subscriptions.get GotSubscriptions )


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Subscriptions" ]
        , renderSubscriptions model.subscriptions
        ]


renderSubscriptions : Maybe (List Subscription) -> Html Msg
renderSubscriptions subscriptions =
    case subscriptions of
        Nothing ->
            text "Loading up..."

        Just subs ->
            subs
                |> List.map (Views.Subscriptions.render SubscriptionChange)
                |> div [ class "subscriptions" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSubscriptions (Ok x) ->
            ( { model | subscriptions = Just x }, Cmd.none )

        GotSubscriptions (Err e) ->
            ( model, Cmd.none )

        SubscriptionChange id selection ->
            let
                request =
                    Requests.Subscriptions.update model.csrfToken SubscriptionUpdated id selection
            in
            ( model, request )

        SubscriptionUpdated (Ok list) ->
            let
                updateSubscriptions new old =
                    case old of
                        [] ->
                            []

                        h :: t ->
                            { h | subscribed = List.member h.id new } :: updateSubscriptions new t

                newSubscriptions =
                    model.subscriptions
                        |> Maybe.map (updateSubscriptions list)
            in
            ( { model | subscriptions = newSubscriptions }, Cmd.none )

        _ ->
            ( model, Cmd.none )


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \x -> Sub.none
        }
