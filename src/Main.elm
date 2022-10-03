module Main exposing (main)

import Browser
import Css
import Css.Global
import Csv exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http


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
    ( { allMasters = []
      , title = ""
      , csv = Csv [] []
      , userState = Init
      , rawData = ""
      }
    , Cmd.none
    )



-- MODEL


type UserState
    = Init
    | Waiting
    | Loaded
    | Failed Http.Error


type alias Model =
    { allMasters : List String
    , title : String
    , rawData : String
    , csv : Csv
    , userState : UserState
    }


type alias Topic =
    { name : String, id : Int }



-- UPDATE


type Msg
    = Click String
    | GotCsv (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click masterId ->
            ( { model | title = masterId, csv = Csv [] [], userState = Waiting }
            , Http.get { url = "https://mscs.konicaminolta.jp/hc/article_attachments/4406428328857/AIsee_______________________.csv", expect = Http.expectString GotCsv }
            )

        GotCsv (Ok rawData) ->
            ( { model
                | userState = Loaded
                , rawData = rawData
                , csv = Csv.parse rawData
              }
            , Cmd.none
            )

        GotCsv (Err e) ->
            ( { model | userState = Failed e }, Cmd.none )


parseCsv : String -> Csv
parseCsv rawData =
    Csv.parse rawData


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [ id "left-column" ]
            [ h1 [] [ text "master_list" ]
            , span [] [ text model.title ]
            , button [ onClick (Click model.title) ] [ text ("Load" ++ model.title) ]
            , nav []
                [ div [ class "master_list" ]
                    [ ul [] (List.map viewMasterId model.allMasters)
                    ]
                ]
            ]
        , div [ id "right-column" ]
            [ h1 [] [ text "masters" ]
            , div []
                [ text model.rawData
                ]
            , div []
                [ viewUserState model.userState
                ]
            , div []
                [ viewTable model.csv
                ]
            ]
        ]


viewMasterId : String -> Html Msg
viewMasterId masterId =
    li [] [ text masterId ]


viewUserState : UserState -> Html Msg
viewUserState userState =
    case userState of
        Init ->
            text "Init"

        Waiting ->
            text "Init"

        Loaded ->
            text "Loaded"

        Failed e ->
            text ("Failed" ++ Debug.toString e)


viewTable : Csv -> Html Msg
viewTable csv =
    table []
        (viewTableLine csv.headers :: List.map viewTableLine csv.records)


viewTableLine : List String -> Html Msg
viewTableLine data =
    tr [] (List.map viewTableData data)


viewTableData : String -> Html Msg
viewTableData data =
    td [] [ text data ]
