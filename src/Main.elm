module Main exposing (..)

import Browser
import Html exposing (Html, input, text, br, div, h1, button, node, label)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)
import Debug
import Cognito


---- MODEL ----

type alias EmailAddress = String

type alias Username = String

type alias Password = String

type alias ErrorMessage = Maybe String

type Model
    = LoggedOut EmailAddress Username Password ErrorMessage
    | AwaitingVerification Username


initialModel : Model
initialModel =
    LoggedOut "" "" "" (Just "")

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
    | CognitoSignupSuccess { username : String }

--signUp :


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        AwaitingVerification username ->
            case msg of
                _ ->
                    ( model, Cmd.none )

        LoggedOut currentEmailAddress currentUsername currentPassword errorMessage ->
            case Debug.log "update" msg of
                DoSignUp ->
                    ( model, Cognito.signup { emailAddress = currentEmailAddress, password = currentPassword, username = currentUsername } )

                SetEmailAddress emailAddress ->
                    ( LoggedOut emailAddress currentUsername currentPassword errorMessage, Cmd.none )

                SetPassword password ->
                    ( LoggedOut currentEmailAddress currentUsername password errorMessage, Cmd.none )

                SetUsername username ->
                    ( LoggedOut currentEmailAddress username currentPassword errorMessage, Cmd.none )

                CognitoError error ->
                    ( LoggedOut currentEmailAddress currentUsername currentPassword (Just error), Cmd.none )

                CognitoSignupSuccess { username } ->
                    ( AwaitingVerification username, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    case model of
        AwaitingVerification username ->
            div []
                [ h1 [] [ text ("Thanks for signing up, " ++ username ++ "! Please verify your account") ]
                ]

        LoggedOut emailAddress username password errorMessage ->
            div []
                [ node "error" 
                    []
                    [ case errorMessage of
                        Just err ->
                            text err

                        Nothing ->
                            text ""
                    ]
                , h1 [] [ text "Welcome! Please sign up." ]
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