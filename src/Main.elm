module Main exposing (..)

import Browser
import Html exposing (Html, input, text, br, div, h2, button, label)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)
import Debug
import Cognito


---- MODEL ----

type alias EmailAddress = String

type alias Username = String

type alias Password = String

type Model
    = LoggedOut EmailAddress Username Password
    | AwaitingVerification


initialModel : Model
initialModel =
    LoggedOut "" "" ""

init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )

---- UPDATE ----

type Msg
    = DoSignUp
    | SetEmailAddress EmailAddress
    | SetPassword Password
    | SetUsername Username
    | CognitoError String
    | CognitoSignupSuccess { emailAddress : String }

--signUp :


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        AwaitingVerification ->
            case msg of
                _ ->
                    ( model, Cmd.none )

        LoggedOut currentEmailAddress currentUsername currentPassword ->
            case Debug.log "update" msg of
                DoSignUp ->
                    ( model, Cognito.signup { emailAddress = currentEmailAddress, password = currentPassword, username = currentUsername } )

                SetEmailAddress emailAddress ->
                    ( LoggedOut emailAddress currentUsername currentPassword, Cmd.none )

                SetPassword password ->
                    ( LoggedOut currentEmailAddress currentUsername password, Cmd.none )

                SetUsername username ->
                    ( LoggedOut currentEmailAddress username currentPassword, Cmd.none )

                CognitoError error ->
                    ( model, Cmd.none )

                CognitoSignupSuccess emailAddress ->
                    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    case model of
        AwaitingVerification ->
            div []
                [ h2 [] [ text "Thanks for signing up! Please verify your account" ]
                ]

        LoggedOut emailAddress username password ->
            div []
                [ h2 [] [ text "Welcome! Please sign up." ]
                , br [] []
                , label [] [ text "Email address" ]
                , input [ onInput SetEmailAddress ] []
                , br [] []
                , label [] [ text "Username" ]
                , input [ onInput SetUsername ] []
                , br [] []
                , label [] [ text "Password" ]
                , input [ onInput SetPassword
                , type_ "password" ] []
                , br [] []
                , button
                    [ onClick (DoSignUp) ]
                    [ text "Sign up" ]
                ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = \model ->
            Sub.batch
                [ Cognito.signupSuccess CognitoSignupSuccess
                , Cognito.errors CognitoError
                ]
        }
