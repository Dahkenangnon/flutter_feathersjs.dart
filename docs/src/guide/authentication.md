# Authentication

Because we have two parts (socketio and rest) which must communicate
with the same server (which required maybe authentication) we must found a way to authenticate
both rest & socketio once user is logged.

Below, how to authenticate rest only or socketio only. But notice that in a production app,
you don't need to auth speratly the different client, just use the global authentication method.
Nice ? Go :rocket:

## Rest only

You can for testing purpose only authenticate the rest client by doing the following.
Note that when you use an other stratagy different from email/pass strategy, you must configure it on your server.

```dart
    try {
      var user = await flutterFeathersjs.rest.authenticate(
          userName: "dah.kenangnon@flutter_feathersjs.com",
      password: "flutter_feathersjs");
      //TODO: Authentication is Ok, save user in local storage

    } on FeatherJsError catch (e) {
      if (e.type == FeatherJsErrorType.IS_INVALID_CREDENTIALS_ERROR) {
        //TODO: Invalid credentials
      } else if (e.type == FeatherJsErrorType.IS_INVALID_STRATEGY_ERROR) {
       //TODO: Invalid strategy
      } else if (e.type == FeatherJsErrorType.IS_AUTH_FAILED_ERROR) {
        //TODO: Invalid authentication failed for other reason.
        // verbose => print(e.message);
      }
      //TODO: Check for other FeatherJsErrorType
      // => print(e.type);
    } catch (e) {
       //TODO: Authentication failed for unkknown reason.
        // why => print(e.type);
        // why => print(e.message);
    }

```

## Socketio only

The process to authenticate the socketio client is done after rest auth is done because,
it use the JWT retrieved by rest client when process finished with ok.

```dart

  // Note: This must be call after rest auth success
  // Not recommanded to use this directly
  try {
       bool isReAuthenticated = await flutterFeathersjs.scketio.authWithJWT();

      //print(isReAuthenticated); => true

    } on FeatherJsError catch (e) {
      if (e.type == FeatherJsErrorType.IS_JWT_TOKEN_ERROR) {
        //TODO: Error using the JWT to authenticated
        // Redirect user to login page
      }else{
        //TODO: Check for other FeatherJsErrorType
        // why => print(e.type);
        // why => print(e.message);
      }
    } catch (e) {
       //TODO: Authentication failed for unkknown reason.
        // why => print(e.type);
        // why => print(e.message);
    }

```

## Global  (recommended)

### Autenticate

Go to login page, retrieve user credentials and authenticat user
with different strategy

```dart
 try {

      // Default strategy (email/password => local strategy)
      var user = await flutterFeathersjs.authenticate(
          userName: "dah.kenangnon@flutter_feathersjs.com",
      password: "flutter_feathersjs");

      // Or use what you want, e.g: phone/password
      // Auth with rest client with phone/password strategy
      // Note: You must configure your server for this strategy to work
   var user = await flutterFeathersjs.authenticate(
      strategy: "phone",
      userNameFieldName: "tel", // "tel" is the fieldname on the mongoose|? model
      userName:"+22900000000",
      password: "flutter_feathersjs");


      //TODO: Authentication is Ok, save user in local storage

    } on FeatherJsError catch (e) {
      if (e.type == FeatherJsErrorType.IS_INVALID_CREDENTIALS_ERROR) {
        //TODO: Invalid credentials
      } else if (e.type == FeatherJsErrorType.IS_INVALID_STRATEGY_ERROR) {
       //TODO: Invalid strategy
      } else if (e.type == FeatherJsErrorType.IS_AUTH_FAILED_ERROR) {
        //TODO: Invalid authentication failed for other reason.
        // verbose => print(e.message);
      }
      //TODO: Check for other FeatherJsErrorType
      // => print(e.type);
    } catch (e) {
       //TODO: Authentication failed for unkknown reason.
        // why => print(e.type);
        // why => print(e.message);
    }
```

## ReAuthenticate on app restarted

Then reAutenticate user, if JWT still validated without request credentials from user on app restart

```dart
 try {
       bool isReAuthenticated = await flutterFeathersjs.reAuthenticate();

      //print(isReAuthenticated); => true

    } on FeatherJsError catch (e) {
      if (e.type == FeatherJsErrorType.IS_AUTH_FAILED_ERROR) {
        //TODO: ReAutentication failed
        // Redirect user to login page
      }else{
        //TODO: Check for other FeatherJsErrorType
        // why => print(e.type);
        // why => print(e.message);
      }
    } catch (e) {
       //TODO: Authentication failed for unkknown reason.
        // why => print(e.type);
        // why => print(e.message);
    }
```






Now, let's send request and listen to feathers js event :notes: :zzz: :car: