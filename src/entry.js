//Set up Cognito
var cognitoUserPoolIds = require('../ids/cognito_ids');

var AmazonCognitoIdentity = require('amazon-cognito-identity-js');
var CognitoUserPool = AmazonCognitoIdentity.CognitoUserPool;

var poolData = {
  UserPoolId: cognitoUserPoolIds.userPoolId, // Your user pool id here
  ClientId: cognitoUserPoolIds.clientId // Your client id here
};
var userPool = new CognitoUserPool(poolData);

// Set up Elm
var app = Elm.Main.init({
  node: document.getElementById('elm')
});

// what happens on sign up
app.ports.signup.subscribe(function (data) {
  // callback for port - sign up
  console.log('data: ' + JSON.stringify(data));
  var attributeList = [];

  var dataEmail = {
    Name: 'email',
    Value: data.emailAddress
  };

  var attributeEmail = new AmazonCognitoIdentity.CognitoUserAttribute(dataEmail);

  attributeList.push(attributeEmail);

  userPool.signUp(data.username, data.password, attributeList, null, function (err, result) {
    if (err) {
      var errorMessage = err.message || JSON.stringify(err);
      app.ports.errors.send(errorMessage);
      return;
    }
    var cognitoUser = result.user;
    app.ports.signupSuccess.send({ username: cognitoUser.getUsername() });
  });
});

