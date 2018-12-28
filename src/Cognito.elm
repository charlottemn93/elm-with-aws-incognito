port module Cognito exposing (signup, errors, signupSuccess)

port signup : { emailAddress: String, password: String, username: String } -> Cmd msg

port errors : (String -> msg) -> Sub msg

port signupSuccess : ({ username: String} -> msg) -> Sub msg