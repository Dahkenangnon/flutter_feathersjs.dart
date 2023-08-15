<div align="center">
<h1>FlutterFeathersJs</h1>
 <br> 

![FlutterFeathersJs](doc/ff-663x181.png)

 <br> <br>
>
> `The road to the feathersjs headquarters https://feathersjs.com/`
>
>
 <br> <br>
</div>



[![GitHub Repo stars](https://img.shields.io/github/stars/dahkenangnon/flutter_feathersjs.dart?label=github%20stars)](https://github.com/dahkenangnon/flutter_feathersjs)
[![pub version](https://img.shields.io/pub/v/flutter_feathersjs)](https://pub.dev/packages/flutter_feathersjs)
[![GitHub last commit](https://img.shields.io/github/last-commit/dahkenangnon/flutter_feathersjs.dart)](https://github.com/dahkenangnon/flutter_feathersjs)
[![GitHub license](https://img.shields.io/github/license/dahkenangnon/flutter_feathersjs.dart)](./LICENSE)



FlutterFeathersJs is a Flutter package designed to simplify the development of real-time applications using the FeathersJS Node framework. It provides an intuitive API and seamless integration between Flutter and FeathersJS, empowering developers to build powerful and responsive real-time applications with ease.

## Features

- **Effortless Integration**: Seamlessly connect your Flutter frontend with your FeathersJS backend using FlutterFeathersJs's simple and straightforward API.
- **Real-Time Communication**: Utilize FeathersJS's real-time capabilities to create dynamic and interactive Flutter applications.
- **Authentication Support**: Authenticate users using email/password or tokens, ensuring secure communication between your Flutter app and FeathersJS server.
- **Socket.io or REST Client**: Choose between Socket.io or REST client to suit your project's needs and communication preferences.
- **Event Handling**: Leverage FeathersJS's event-driven architecture to handle real-time events and updates efficiently.
- **Scalable and Reliable**: Benefit from FeathersJS's scalability options and FlutterFeathersJs's robust design to build reliable real-time applications.

## Installation

To start using FlutterFeathersJs, add it to your project's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_feathersjs: ^latest_version
```

Replace `latest_version` with the latest version of FlutterFeathersJs available on [pub.dev](https://pub.dev/packages/flutter_feathersjs).

Then, run the following command in your project's root directory:

```bash
flutter pub get
```

## Getting Started

To get started with FlutterFeathersJs, follow these steps:

1. Import the FlutterFeathersJs package into your Flutter project:

   ```dart
   import 'package:flutter_feathersjs/flutter_feathersjs.dart';
   ```

2. Initialize FlutterFeathersJs as a single instance:

   ```dart
   const BASE_URL = "https://your-feathersjs-server.com";

   // Use tools like get_it to initialize FlutterFeathersJs globally across your app
   FlutterFeathersjs flutterFeathersjs = FlutterFeathersjs()..init(baseUrl: BASE_URL);
   ```

3. Authenticate a user using email/password:

   ```dart
   var response = await flutterFeathersjs.authenticate(userName: user["email"], password: user["password"]);

   print(response);
   ```

4. Re-authenticate with a token:

   ```dart
   var response = await flutterFeathersjs.reAuthenticate();
   print(response);
   ```

5. Get the authenticated user:

   ```dart
   var response = await flutterFeathersjs.user();
   print(response);
   ```

For more detailed usage examples and API documentation, please refer to the [FlutterFeathersJs documentation](https://pub.dev/documentation/flutter_feathersjs/latest/).

## Configure and Use Socket.io or REST Client

To configure and use either the Socket.io or REST client, follow the examples below:

### Socket.io Client

```dart
FlutterFeathersjs socketIOClient = FlutterFeathersjs();

IO.Socket io = IO.io(BASE_URL);

socketIOClient.configure(FlutterFeathersjs.socketioClient(io));

// Authenticate with Socket.io client
var response = await socketIOClient.authenticate(userName: user["email"], password: user["password"]);

print(response);

// Re-authenticate with Socket.io client
var reAuthResponse = await socketIOClient.reAuthenticate();

// Create a message using Socket.io standalone client
var ioResponse = await socketIOClient.service('messages').create({"text": 'A new message'});

// Get the authenticated user
var userResponse = await socketIOClient.user();
```



### REST Client

```dart
FlutterFeathersjs restClient = FlutterFeathersjs();

Dio dio = Dio(BaseOptions(baseUrl: BASE_URL));

restClient.configure(FlutterFeathersjs.restClient(dio));

// Authenticate user using REST client
var response = await restClient.authenticate(userName: user["email"], password: user["password"]);

print(response);

// Re-authenticate user using REST client
var reAuthResponse = await restClient.reAuthenticate();

// Call service using REST client
var restResponse = await restClient.service('messages').create({"text": 'A new message'});

// Get the authenticated user
var user = await restClient.user();
```

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please create a new issue on the [issue tracker](https://github.com/Dahkenangnon/flutter_feathersjs.dart/issues). Pull requests are also appreciated.

Before contributing, please review our [contribution guidelines](CONTRIBUTING.md).

## License

This project is licensed under the [MIT License](LICENSE).

---

If you find FlutterFeathersJs useful, consider giving it a star on [GitHub](https://github.com/Dahkenangnon/flutter_feathersjs.dart) and sharing it with your friends and colleagues. Happy coding!
