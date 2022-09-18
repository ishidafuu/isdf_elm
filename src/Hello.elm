module Hello exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init, update = update, view = view }



--Model


type alias Model =
    { input : String
    , memos : List String
    }


init : Model
init =
    { input = ""
    , memos = []
    }



--Update


type Msg
    = Input String
    | Submit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input input ->
            { model | input = input }

        Submit ->
            { model
                | input = ""
                , memos = model.input :: model.memos
            }



--View


view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit Submit ]
            [ input [ value model.input, onInput Input ] []
            , button
                [ disabled (String.length model.input < 1) ]
                [ text "Submit" ]
            ]
        , ul [] (List.map viewMemo model.memos)
        ]


viewMemo : String -> Html msg
viewMemo memo =
    li [] [ text memo ]



--header : Html msg
--header =
--    h1 [] [ text "Useful Links" ]
--
--linkItem : String -> String -> Html msg
--linkItem url text_ =
--    li [] [ a [ href url ] [ text text_ ] ]
--
--
--
--
--content : Html msg
--content =
--    ul []
--        [ linkItem "https://elm-lang.org" "Homepage"
--        , linkItem "https://package.elm-lang.org" "Package"
--        , linkItem "https://ellie-app.com" "Playground"
--        , linkItem "https://ellie-app.com" "Playground"
--        ]
