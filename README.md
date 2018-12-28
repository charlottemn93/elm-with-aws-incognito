# elm-with-aws-incognito

*Currently this app is an elm sign up page that only creates an unverified user (more functionality to come!)*

# Prerequisites

Ensure you're running Elm 0.19 (otherwise, the Elm code will not compile)

Create a cognito user pool. The defaults provided by AWS on creation are fine except for attributes - please ensure the only required attributes are email address and open id.

Create a new file `ids/cognito_ids.js`, with the following in it:

```
module.exports = {
    clientId: '', // your app client id
    userPoolId: '', // your user pool id
};
```

# To build

`npm run build`

`elm make --output elm.js src/Main.elm`

# To run

`elm reactor`

enter `http://localhost:8000/elm-cognito.html` in a browser tab
