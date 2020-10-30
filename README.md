# flutter_feathersjs :bird:

Communicate with your feathers js server from flutter.
*__FormData support out the box, auth, reAuth, socketio send event, rest ...__ But event listen via socketio not yet implemented*


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
   // Auth with rest client
   var authResponse = await flutterFeathersjs.rest
      .authenticate(email: user["email"], password: user["password"]);

  //Second time, application will restart, just:
  var reAuthResponse = await flutterFeathersjs.rest.reAuthenticate();

  // Or With socketio
  // Note: This must be call after rest auth success
  var authResponse = await flutterFeathersjs.scketio.authWithJWT();

```

## Simplify yor life, Auth both client one time

```dart

// Auth first time with credentials
var authResponse = await flutterFeathersjs.authenticate(email: null, password: null);

// on App restart, don't disturbe user, just reAuth with with accessToken, early store by FlutterFeathersjs
var reAuthResponse = await flutterFeathersjs.reAuthenticate()

```

## Important

- Listen to event on socketio is not yet implemented
- Documentation is coming
- Contact-me for improvment or contribution purpose
- Example is coming