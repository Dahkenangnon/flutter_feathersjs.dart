import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_feathersjs/flutter_feathersjs.dart';
import 'fixtures.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:dio/dio.dart';

/// These test will fail because of usage of FlutterSecureStorage which can't
/// be used outside of flutter app
///
/// So please run these test in demo flutter app
void main() async {
  /// ----------- Instanciation of the client -------------
  //1. Default behavior
  FlutterFeathersjs flutterFeathersjs = FlutterFeathersjs()
    ..init(baseUrl: BASE_URL);

  //2. Standalone client
  FlutterFeathersjs socketIOClient = FlutterFeathersjs();

  //2.1. Socket.io client
  IO.Socket io = IO.io(BASE_URL);
  socketIOClient.configure(FlutterFeathersjs.socketioClient(io));

  // Create a message using socketio standalone client
  var ioResponse = await socketIOClient
      .service('messages')
      .create({"text": 'A new message'});

  //2.2 Rest client
  FlutterFeathersjs restClient = FlutterFeathersjs();
  Dio dio = Dio(BaseOptions(baseUrl: BASE_URL));
  restClient.configure(FlutterFeathersjs.restClient(dio));

  // Create a message
  var restResponse =
      await restClient.service('messages').create({"text": 'A new message'});

  /// ----------- Authentication -------------
  test(' \n Authenticate user using default client \n ', () async {
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

  test(' \n Authenticate user using socketIOClient standalone client \n ',
      () async {
    try {
      var response = await socketIOClient.authenticate(
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

  test(' \n Authenticate user using restClient standalone client \n ',
      () async {
    try {
      var response = await restClient.authenticate(
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
