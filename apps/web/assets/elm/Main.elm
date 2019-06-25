module Main exposing (main)

import Browser
import Entities.Channel exposing (Channel)
import Entities.Incident exposing (Incident)
import Entities.Subscription exposing (Subscription)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Requests.Incidents
import Requests.Subscriptions
import Time
import Views.Channels
import Views.Incidents
import Views.Subscriptions


type alias Model =
    { subscriptions : Maybe (List Subscription)
    , incidents : Maybe (List Incident)
    , channels : Maybe (List Channel)
    , csrfToken : String
    }


type alias Flags =
    { csrfToken : String }


type Msg
    = NoOp
    | SubscriptionUpdated (Result Http.Error (List String))
    | SubscriptionChange String Bool
    | GotSubscriptions (Result Http.Error (List Subscription))
    | PollForIncidents
    | GotIncidents (Result Http.Error (List Incident))
    | ChannelSubscriptionUpdated String (Result Http.Error (List String))
    | ChannelSubscriptionChange String String Bool


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { subscriptions = Nothing
            , incidents = Nothing
            , channels = Nothing
            , csrfToken = flags.csrfToken
            }
    in
    ( model, Cmd.batch [ Requests.Subscriptions.get GotSubscriptions, Requests.Incidents.get GotIncidents ] )


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Active Incidents" ]
        , renderIncidents model.incidents
        , h3 [] [ text "Your Subscriptions" ]
        , renderSubscriptions model.subscriptions
        , h3 [] [ text "Channels" ]
        , renderChannels model.channels
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


renderIncidents : Maybe (List Incident) -> Html Msg
renderIncidents incidents =
    case incidents of
        Nothing ->
            text "Loading up..."

        Just incs ->
            case incs of
                [] ->
                    text "No Active Incidents!"

                list ->
                    list
                        |> List.map Views.Incidents.render
                        |> div [ class "incidents" ]


renderChannels : Maybe (List Channel) -> Html Msg
renderChannels channels =
    case channels of
        Nothing ->
            text "Loading up..."

        Just chans ->
            chans
                |> List.map Views.Channels.render
                |> div [ class "channels" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSubscriptions (Ok x) ->
            ( { model | subscriptions = Just x }, Cmd.none )

        GotIncidents (Ok x) ->
            ( { model | incidents = Just x }, Cmd.none )

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

        PollForIncidents ->
            ( model, Requests.Incidents.get GotIncidents )

        _ ->
            ( model, Cmd.none )


elmSubscriptions : Model -> Sub Msg
elmSubscriptions model =
    Time.every 5000 (\x -> PollForIncidents)


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = elmSubscriptions
        }
