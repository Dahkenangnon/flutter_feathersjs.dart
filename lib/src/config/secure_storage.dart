import 'dart:convert';
import 'constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Flutter Secure Storage bridge for FlutterFeathersjs
///
/// Used to store securely access token and user data
class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> readSecureData(String key) async {
    return await _storage.read(key: key);
  }

  static Future<Map<String, String>> readAllSecureData() async {
    return await _storage.readAll();
  }

  static Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> deleteAllSecureData() async {
    await _storage.deleteAll();
  }

  /// Save the authenticated user data in the secure storage
  ///
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(key: FEATHERSJS_USER, value: json.encode(user));
  }

  /// Get the early stored authenticated user
  ///
  /// return null if no user is stored
  static Future<Map<String, dynamic>> getUser() async {
    final jsonString = await _storage.read(key: FEATHERSJS_USER);
    if (jsonString != null) {
      return json.decode(jsonString);
    } else {
      return {};
    }
  }

  /// Save the authenticated user sent back from feathers js server after login
  ///
  ///
  static Future<void> deleteUser() async {
    await _storage.delete(key: FEATHERSJS_USER);
  }

  /// Save the JWT token for reAuth() purpose
  ///
  /// [accessToken] is the JWT token
  ///
  /// [client] is the standalone client name, if null, the accessToken will be saved in the default key
  ///
  static Future<void> saveAccessToken(String accessToken,
      {String? client}) async {
    if (client == "rest") {
      await _storage.write(
          key: FEATHERSJS_REST_ACCESS_TOKEN, value: accessToken);
    } else if (client == "socketio") {
      await _storage.write(
          key: FEATHERSJS_SOCKETIO_ACCESS_TOKEN, value: accessToken);
    } else {
      await _storage.write(key: FEATHERSJS_ACCESS_TOKEN, value: accessToken);
    }
  }

  /// Get the early stored JWT for reAuth() purpose
  ///
  /// [client] is optional, if you are using standalone clients, you can specify the client name
  ///
  ///
  static Future<String?> getAccessToken({String? client}) async {
    if (client == "rest") {
      return await _storage.read(key: FEATHERSJS_REST_ACCESS_TOKEN);
    } else if (client == "socketio") {
      return await _storage.read(key: FEATHERSJS_SOCKETIO_ACCESS_TOKEN);
    } else {
      return await _storage.read(key: FEATHERSJS_ACCESS_TOKEN);
    }
  }

  /// Delete the early stored JWT for reAuth() purpose
  ///
  /// [client] is optional, if you are using standalone clients, you can specify the client name
  static Future<void> deleteAccessToken({String? client}) async {
    if (client == "rest") {
      await _storage.delete(key: FEATHERSJS_REST_ACCESS_TOKEN);
    } else if (client == "socketio") {
      await _storage.delete(key: FEATHERSJS_SOCKETIO_ACCESS_TOKEN);
    } else {
      await _storage.delete(key: FEATHERSJS_ACCESS_TOKEN);
    }
  }
}
