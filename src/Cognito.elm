port module Cognito exposing (signup, errors, signupSuccess)

port signup : { emailAddress: String, password: String, username: String } -> Cmd msg

port errors : (String -> msg) -> Sub msg  --JS is gonna send a string and we'll receive it in Elm as a subscription

port signupSuccess : ({ emailAddress: String} -> msg) -> Sub msg