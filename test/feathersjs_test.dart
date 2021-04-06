import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_feathersjs/flutter_feathersjs.dart';
import 'package:flutter_feathersjs/src/helper.dart';

//Fixtures contains sample data for processing test with a feathers js client
import 'fixtures.dart';

void main() async {
  /// Initialization
  FlutterFeathersjs flutterFeathersjs = FlutterFeathersjs()
    ..init(baseUrl: BASE_URL);

  /// Testing global methods
  test(' \n Test global methods \n ', () async {
    try {
      var rep2 = await flutterFeathersjs.authenticate(
          userName: user["email"], password: user["password"]);
      print("\n  The authenticated  user is: \n");
      //rep2 = await flutterFeathersjs.reAuthenticate();

      // var rep2 = await flutterFeathersjs.authenticate(
      //     userName: user["email"], password: user["password"]);
      // print("\n  The authenticated  user is: \n");
      // print(rep2);
    } on FeatherJsError catch (e) {
      // Catch error from feahters js
      //
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
    } catch (e) {
      print("Bad error here");
      print(e.message);
    }
  });

  /// Testing socketio methods
  test(' \n Find method of rest client  \n', () async {
    try {
      var rep2 = await flutterFeathersjs.find(serviceName: "users", query: {});
      print("\n  Founds news are: \n");
      print(rep2);
    } on FeatherJsError catch (e) {
      print("Error");
      print(e.type);
      print(e.message);
    } catch (er) {
      print("Other error");
      print(er);
    }
  });

  /// Testing rest methos
  // test(' \n Test rest methods \n ', () async {
  //   try {
  //     var rep2 = await flutterFeathersjs.create(
  //         serviceName: "users",
  //         data: {"email": user["email"], "password": user["password"]});
  //     print("\n  The newly created user is: \n");
  //     print(rep2);
  //   } on FeatherJsError catch (e) {
  //     // Catch error from feahters js
  //     //
  //     if (e.type == FeatherJsErrorType.IS_SERVER_ERROR) {
  //       print("Error is from feathers js api server");
  //     } else if (e.type == FeatherJsErrorType.IS_REST_ERROR) {
  //       print("Error is from rest methods");
  //     } else if (e.type == FeatherJsErrorType.IS_SOCKETIO_ERROR) {
  //       print("from socketio error");
  //     } else {
  //       print("incconnu error");
  //       print(e.type);
  //     }
  //     print(e.message);
  //   } catch (e) {
  //     print("Last ca");
  //     print(e.message);
  //   }
  // });c
}
