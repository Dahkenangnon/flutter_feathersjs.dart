import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_feathersjs/flutter_feathersjs.dart';

import 'fixtures.dart';

void main() async {
  FlutterFeathersjs flutterFeathersjs = FlutterFeathersjs()
    ..init(baseUrl: BASE_URL);

  test(' \n Authenticate user \n ', () async {
    try {
      var response = await flutterFeathersjs.authenticate(
          userName: user["email"], password: user["password"]);
      print("\n  The authenticated  user is: \n");
      print(response);
    } on FeatherJsError catch (e) {
      if (e.type == FeatherJsErrorType.IS_INVALID_CREDENTIALS_ERROR) {
        print("Invalid credentials");
      } else if (e.type == FeatherJsErrorType.IS_INVALID_STRATEGY_ERROR) {
        print("Invalid strategy");
      } else if (e.type == FeatherJsErrorType.IS_GENERAL_ERROR) {
        print("Server error");
      } else {
        print("Unknown error");
        print(e.type);
        print(e.message);
      }
    } on Error catch (e) {
      print("Bad error here");
      print(e);
    }
  });
}
