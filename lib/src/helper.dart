import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/// Use to save feathers js token
const String FEATHERSJS_ACCESS_TOKEN = "FEATHERSJS_ACCESS_TOKEN";

/// Socketio Connected
class Connected {}

/// Socketio Disconnected
class DisConnected {}

/// Utilities for FlutterFeathersJs
class FeatherjsHelper {
  SharedPreferences prefs;
  FeatherjsHelper();

  /// Store JWT for reAuth() purpose
  Future<bool> setAccessToken({String token}) async {
    prefs = await SharedPreferences.getInstance();

    return await prefs.setString(FEATHERSJS_ACCESS_TOKEN, token);
  }

  /// Get the early stored JWT for reAuth() purpose
  Future<String> getAccessToken({String token}) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(FEATHERSJS_ACCESS_TOKEN);
  }
}

/// FeatherJsErrorType
enum FeatherJsErrorType {
  // This error come from  your feathers js server
  IS_SERVER_ERROR,

  /// This error come from any FlutterFeathersjs.rest's method
  IS_REST_ERROR,

  /// This error come from any FlutterFeathersjs.scketio's method
  IS_SOCKETIO_ERROR,

  /// Error when derialiazing realtime object in socketio listen method
  IS_DESERIALIZATION_ERROR,

  /// Unknown error
  IS_UNKNOWN_ERROR,

  /// When in auth method, jwt cause a problem
  IS_JWT_TOKEN_ERROR,

  /// Error while building form data in rest client
  IS_FORM_DATA_ERROR,

  /// Jwt not found in local storage
  IS_JWT_TOKEN_NOT_FOUND_ERROR,
  // Jwt is invalid
  IS_JWT_INVALID_ERROR,
  // Jwt expired
  IS_JWT_EXPIRED_ERROR,
  // User credentials are wrong for authentication on the server
  IS_INVALID_CREDENTIALS_ERROR,
  // Wrong strategy is given to the auth method
  IS_INVALID_STRATEGY_ERROR,
  // Auth failed with unknown reason
  IS_AUTH_FAILED_ERROR,
}

/// FeatherJsError describes the error info  when request failed.
class FeatherJsError implements Exception {
  FeatherJsError({
    this.type = FeatherJsErrorType.IS_UNKNOWN_ERROR,
    this.error,
  });

  FeatherJsErrorType type;

  dynamic error;

  StackTrace _stackTrace;

  set stackTrace(StackTrace stack) => _stackTrace = stack;

  StackTrace get stackTrace => _stackTrace;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'FeatherJsError [$type]: $message';
    if (_stackTrace != null) {
      msg += '\n$stackTrace';
    }
    return msg;
  }
}

/// Feathers Js realtime event data
class FeathersJsEventData<T> {
  FeathersJsEventType type;
  T data;
  FeathersJsEventData({this.type, this.data});
}

/// Feathers Js realtime event type
enum FeathersJsEventType { updated, patched, created, removed }
