module Views.Incidents exposing (render)

import Entities.Incident exposing (Incident)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


render : Incident -> Html msg
render incident =
    div [ class "incident", class ("incident--" ++ incident.status) ]
        [ h4 [ class "incident__title" ] [ a [ href incident.url ] [ text incident.title ] ]
        ]
