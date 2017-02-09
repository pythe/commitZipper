module Commit exposing (..)

import Json.Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline as Decode
import Html exposing (..)
import Html.Attributes exposing (..)


type Commits
    = Commits (List Commit)


type Commit
    = Commit
        { sha : String
        , message : String
        , author : String
        , authorAvatarUrl : String
        , url : String
        }


initCommits : List Commit -> Commits
initCommits commits =
    Commits commits


init : String -> String -> String -> String -> String -> Commit
init sha message author authorAvatarUrl url =
    Commit
        { sha = sha
        , message = message
        , author = author
        , authorAvatarUrl = authorAvatarUrl
        , url = url
        }


commitsDecoder : Decoder Commits
commitsDecoder =
    Decode.decode Commits
        |> Decode.custom (Json.Decode.list commitDecoder)


commitDecoder : Decoder Commit
commitDecoder =
    Decode.decode init
        |> Decode.required "sha" string
        |> Decode.requiredAt [ "commit", "message" ] string
        |> Decode.requiredAt [ "author", "login" ] string
        |> Decode.requiredAt [ "author", "avatar_url" ] string
        |> Decode.required "html_url" string


message : Commit -> String
message (Commit { message }) =
    message


avatarUrl : Commit -> String
avatarUrl (Commit { authorAvatarUrl }) =
    authorAvatarUrl


index : Commits -> Html msg
index (Commits commits) =
    div [] <| List.map view commits


view : Commit -> Html msg
view commit =
    div []
        [ div [] [ img [ src <| avatarUrl commit, width 50 ] [] ]
        , div [] [ text <| message commit ]
        ]
