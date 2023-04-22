import 'dart:convert';
import 'constants.dart';
import 'package:json_bridge/json_bridge.dart';

/// Storage bridge for FlutterFeathersjs
///
/// Used to store access token and user data
///
/// Be aware that this is not secure storage, use any more secure storage instead
class JsonStorage {

  // Omit dir to use your flutter application document directory
  JSONBridge jsonBridge = JSONBridge()..init(fileName: 'config', dir: 'test');

  /// Save the authenticated user data in the secure storage
  ///
   Future<void> saveUser(Map<String, dynamic> user) async {
    jsonBridge.set(FEATHERSJS_USER, json.encode(user));
  }

  /// Get the early stored authenticated user
  ///
  /// return null if no user is stored
   Future<Map<String, dynamic>> getUser() async {
    final jsonString = jsonBridge.get(FEATHERSJS_USER);
    if (jsonString != null) {
      return json.decode(jsonString);
    } else {
      return {};
    }
  }

  /// Save the authenticated user sent back from feathers js server after login
  ///
  ///
   Future<void> deleteUser() async {
    jsonBridge.delete(FEATHERSJS_USER);
  }

  /// Save the JWT token for reAuth() purpose
  ///
  /// [accessToken] is the JWT token
  ///
  /// [client] is the standalone client name, if null, the accessToken will be saved in the default key
  ///
   Future<void> saveAccessToken(String accessToken,
      {String? client}) async {
    if (client == "rest") {
      jsonBridge.set(FEATHERSJS_REST_ACCESS_TOKEN, accessToken);
    } else if (client == "socketio") {
      jsonBridge.set(FEATHERSJS_SOCKETIO_ACCESS_TOKEN, accessToken);
    } else {
      jsonBridge.set(FEATHERSJS_ACCESS_TOKEN, accessToken);
    } 
  }

  /// Get the early stored JWT for reAuth() purpose
  ///
  /// [client] is optional, if you are using standalone clients, you can specify the client name
  ///
  ///
   Future<String?> getAccessToken({String? client}) async {
    if (client == "rest") {
      return jsonBridge.get(FEATHERSJS_REST_ACCESS_TOKEN);
    } else if (client == "socketio") {
      return jsonBridge.get(FEATHERSJS_SOCKETIO_ACCESS_TOKEN);
    } else {
      return jsonBridge.get(FEATHERSJS_ACCESS_TOKEN);
    }
  }

  /// Delete the early stored JWT for reAuth() purpose
  ///
  /// [client] is optional, if you are using standalone clients, you can specify the client name
   Future<void> deleteAccessToken({String? client}) async {
    if (client == "rest") {
      jsonBridge.delete(FEATHERSJS_REST_ACCESS_TOKEN);
    } else if (client == "socketio") {
      jsonBridge.delete(FEATHERSJS_SOCKETIO_ACCESS_TOKEN);
    } else {
      jsonBridge.delete(FEATHERSJS_ACCESS_TOKEN);
    } 
  }
}

