# Installation


## Update your pubspec.yaml

```yaml
flutter_feathersjs: ^lastest
```

## Import it in your flutter code

```dart

import 'package:flutter_feathersjs/flutter_feathersjs.dart';

```

## Initialize it

```dart


//your  api
const BASE_URL = "https://api.my-featherjs-domain.com";

FlutterFeathersjs flutterFeathersjs = FlutterFeathersjs()
    ..init(baseUrl: BASE_URL);

```

You're ready to go