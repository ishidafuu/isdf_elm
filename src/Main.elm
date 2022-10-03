module Main exposing (main)

import Browser
import Csv exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( { title = "", csv = Csv [] [] }
    , Cmd.none
    )



-- MODEL


type alias Model =
    { title : String
    , csv : Csv
    }


type alias Topic =
    { name : String, id : Int }



-- UPDATE


type Msg
    = Click String
    | SetCsv Csv


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click masterId ->
            ( {}, Cmd.none )

        SetCsv csv ->
            ( { model | csv = csv }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [ id "left-column" ]
            [ h1 [] [ text "Elmtalk" ]
            , nav []
                [ div [ class "debug" ]
                    [ span [] [ text model.message ]
                    , button [ onClick (SayHello "世界樹") ] [ text "hello" ]
                    , button [ onClick SayBye ] [ text "bye" ]
                    ]
                , div [] (List.map topicListItem model.topics)
                ]
            ]
        , div [ id "right-column" ] [ text "..." ]
        ]


topicListItem : Topic -> Html Msg
topicListItem topic =
    div [ class "topic" ] [ text topic.name ]
