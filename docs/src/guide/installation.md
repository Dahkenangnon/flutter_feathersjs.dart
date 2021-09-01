# Installation


## Update your pubspec.yaml

```yaml
# Please see https://pub.dev/packages/flutter_feathersjs/install
flutter_feathersjs: ^lastest
```

## Import it in your flutter code

```dart
// Import it
import 'package:flutter_feathersjs/flutter_feathersjs.dart';

```

## Initialize it

```dart


//your  api baseUrl
const BASE_URL = "https://flutter-feathersjs.herokuapp.com";

// Init it globally accross your app, maybe with get_it or something like that
FlutterFeathersjs flutterFeathersjs = FlutterFeathersjs()
    ..init(baseUrl: BASE_URL);

```

You're ready to go: 3, 2, 1 :rocket:  