# :bird: flutter_feathersjs :bird:

[![GitHub Repo stars](https://img.shields.io/github/stars/dahkenangnon/flutter_feathersjs.dart?label=github%20stars)](https://github.com/dahkenangnon/flutter_feathersjs)
[![pub version](https://img.shields.io/pub/v/flutter_feathersjs)](https://pub.dev/packages/flutter_feathersjs)
[![GitHub last commit](https://img.shields.io/github/last-commit/dahkenangnon/flutter_feathersjs.dart)](https://github.com/dahkenangnon/flutter_feathersjs)

<p align="center">
 <img width="460" alt="FlutterFeathersJs Icon" height="300" src="https://dahkenangnon.github.io/flutter_feathersjs.dart/assets/img/logo.png">
 <br>
 Communicate with your feathers js  server from flutter app with unbelieved ease and make happy your customers.
 <br><br><br>

</p>

`Infos: Feathers js is a node framework for real-time applications and REST APIs.`

<br>

## Join the community on Telegram
    
[![Join us on Telegram](https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/flutter_featherjs)

## Simple to use

### 1.  Install it

```yaml
# Please see https://pub.dev/packages/flutter_feathersjs/install
flutter_feathersjs: ^lastest
```

### 2. Import it

```dart
// Import it
import 'package:flutter_feathersjs/flutter_feathersjs.dart';

```

### 3. Initialize it as single instance

```dart


    //your  api baseUrl
    const BASE_URL = "https://flutter-feathersjs.herokuapp.com";

    // Init it globally across your app, maybe with get_it or something like that
    FlutterFeathersjs flutterFeathersjs = FlutterFeathersjs()..init(baseUrl: BASE_URL);

    // Authenticate with email/password
    var response = await flutterFeathersjs.authenticate(userName: user["email"], password: user["password"]);
    print(response);

    // ReAuthenticated with token
    var response = await flutterFeathersjs.reAuthenticate();
    print(response);

    // Get authenticated user
    var response = await flutterFeathersjs.user();

```

### 4. Configure and use only socketio or rest client


```dart

    // Standalone socket io client
    FlutterFeathersjs socketIOClient = FlutterFeathersjs();

    // Socket.io client
     IO.Socket io = IO.io(BASE_URL);
    socketIOClient.configure(FlutterFeathersjs.socketioClient(io));

    // Auth socketio client 

    var response = await socketIOClient.authenticate(userName: user["email"], password: user["password"]);
    print(response);

    // ReAuth socketio client
    var reAuthResponse = await socketIOClient.reAuthenticate();
    
    // Create a message using socketio standalone client
    var ioResponse = await socketIOClient.service('messages').create({"text": 'A new message'});

    // Get the authenticated user 
    var userResponse = await socketIOClient.user();

```

```dart

    //StandAlone rest client
    FlutterFeathersjs restClient = FlutterFeathersjs();
    Dio dio = Dio(BaseOptions(baseUrl: BASE_URL));
    restClient.configure(FlutterFeathersjs.restClient(dio));


    // Authenticate user using rest client
    var response = await restClient.authenticate( userName: user["email"], password: user["password"]);
      print(response);

    // Reauthenticate user using rest client
    var reAuthResponse = await restClient.reAuthenticate();

    // Call service 
    var restResponse = await restClient.service('messages').create({"text": 'A new message'});


    // Get the authenticated user
    var user = await restClient.user();


```

**You're ready to go: 3, 2, 1 :rocket:** Checkout the [doc](https://dahkenangnon.github.io/flutter_feathersjs.dart/) for more info.


## Documentation

Check it out at: [https://dahkenangnon.github.io/flutter_feathersjs.dart/](https://dahkenangnon.github.io/flutter_feathersjs.dart/)

## Support

Please email to **dah.kenangnon (at) gmail (dot) com** if you have any questions or comments or business support.

## Contributing

Please feel free to contribute to this project by opening an issue or creating a pull request.
