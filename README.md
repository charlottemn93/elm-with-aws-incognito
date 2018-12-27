# elm-with-aws-incognito

Ensure you're running Elm 0.19

In order to run this, you need to have created a cognito user pool. The defaults are fine, make sure the only required attribute is are email address and open id.

Create a new file ids/cognito_ids.js, with the following in it:

```
module.exports = {
    clientId: '', // your app client id
    appWebDomain: '', // your app web domain
    userPoolId: '', // your user pool id
};
```

# To build

`npm run build`

`elm make --output elm.js src/Main.elm`

# To run

`elm reactor`

enter `http://localhost:8000/elm-cognito.html` in browser tab
