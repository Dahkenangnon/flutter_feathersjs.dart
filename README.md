# :bird: flutter_feathersjs :bird:

Communicate with your feathers js (https://feathersjs.com/) server from flutter.

`Infos: Feathers js is a node framework for real-time applications and REST APIs.`


*__FormData support out the box, auth, reAuth, socketio send event, rest ...__ 

## Import it

```dart
import 'package:flutter_feathersjs/flutter_feathersjs.dart';

```

## Init

```dart
FlutterFeathersjs flutterFeathersjs = FlutterFeathersjs()
    ..init(baseUrl: BASE_URL);

```

## Authentication with either with rest or socketio

```dart
   // Auth with rest client with email/password [Default strategy is email/password]
   var authResponse = await flutterFeathersjs.rest
      .authenticate(userName: user["email"], password: user["password"]);

    // Auth with rest client with phone/password
   var authResponse = await flutterFeathersjs.rest.authenticate(
      strategy: "phone",
      userNameFieldName: "tel",
      userName: user["tel"],
      password: user["password"]);

  //Second time, application will restart, just:
  var reAuthResponse = await flutterFeathersjs.rest.reAuthenticate();

  // Or With socketio
  // Note: This must be call after rest auth success
  // Not recommanded to use this directly
  var authResponse = await flutterFeathersjs.scketio.authWithJWT();

```

## Auth both client one time

```dart

// Auth first time with credentials
 var authResponse = await flutterFeathersjs.authenticate(
      strategy: "phone",
      userNameFieldName: "tel",
      userName: user["tel"],
      password: user["password"]);

// on App restart, don't disturbe user, just reAuth with with accessToken, early store by FlutterFeathersjs
var reAuthResponse = await flutterFeathersjs.reAuthenticate()

```

## Contribution

- Contact-me for improvment or contribution purpose
- Example is coming