# Installation


## Update your pubspec.yaml

```yaml
flutter_feathersjs: ^lastest
```

## Import it in your flutter code

```dart
// Main package
import 'package:flutter_feathersjs/flutter_feathersjs.dart';
// Contains helper like error handling, etc..
import 'package:flutter_feathersjs/src/helper.dart';

```

## Initialize it

```dart


//your  api
const BASE_URL = "https://flutter-feathersjs.herokuapp.com";

// Init it globally accross your app, maybe with get_it
FlutterFeathersjs flutterFeathersjs = FlutterFeathersjs()
    ..init(baseUrl: BASE_URL);

```

You're ready to go :rocket: 