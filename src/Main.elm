module Main exposing (..)

import Html exposing (..)
import Http
import Commit exposing (Commits)


apiKey : String
apiKey =
    "8bdffe6670a334359459f333f8c340af"


type alias Model =
    { commits : Maybe Commits
    , error : Maybe Http.Error
    }


type Msg
    = FetchCommitsResponse (Result Http.Error Commits)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( { commits = Nothing
      , error = Nothing
      }
    , fetchCommits
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchCommitsResponse (Ok commits) ->
            ( { model | commits = Just commits }, Cmd.none )

        FetchCommitsResponse (Err err) ->
            ( { model | error = Just err }, Cmd.none )


subscriptions : model -> Sub msg
subscriptions model =
    Sub.none


view : Model -> Html msg
view model =
    case model.commits of
        Nothing ->
            div [] [ text "Got nothing yet" ]

        Just commits ->
            div [] [ Commit.index commits ]


fetchCommits : Cmd Msg
fetchCommits =
    Http.send FetchCommitsResponse <| Http.get "https://api.github.com/repos/pythe/codenames/commits" Commit.commitsDecoder
