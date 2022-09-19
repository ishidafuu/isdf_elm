module Hello exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as D exposing (Decoder)
import Set exposing (Set)
import Task
import Time


type alias Message =
    { timestamp : Float, data : D.Value }


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



--Model


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )



--Update


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )



--View


view : Model -> Html Msg
view model =
    let
        hour =
            String.fromInt (Time.toHour model.zone model.time)

        minute =
            String.fromInt (Time.toMinute model.zone model.time)

        second =
            String.fromInt (Time.toSecond model.zone model.time)
    in
    h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]



-- Data


type alias User =
    { login : String
    , avatarUrl : String
    , name : String
    , htmlUrl : String
    , bio : Maybe String
    }


userDecoder : Decoder User
userDecoder =
    D.map5 User
        (D.field "login" D.string)
        (D.field "avatar_url" D.string)
        (D.field "name" D.string)
        (D.field "html_url" D.string)
        (D.maybe (D.field "avatar_url" D.string))



--Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick
