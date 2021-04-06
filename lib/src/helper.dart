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
  /// This error come from  your feathers js server
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

  /// Jwt is invalid
  IS_JWT_INVALID_ERROR,

  /// Jwt expired
  IS_JWT_EXPIRED_ERROR,

  /// User credentials are wrong for authentication on the server
  IS_INVALID_CREDENTIALS_ERROR,

  /// Wrong strategy is given to the auth method
  IS_INVALID_STRATEGY_ERROR,

  /// Auth failed with unknown reason
  IS_AUTH_FAILED_ERROR,

  // See https://docs.feathersjs.com/api/errors.html#feathers-errors
  /// Bad request
  IS_BAD_REQUEST_ERROR,

  /// Client not authenticated
  IS_NOT_AUTHENTICATED_ERROR,

  /// PaymentError
  IS_PAYMENT_ERROR,

  /// Accès denied
  IS_FORBIDDEN_ERROR,

  /// Service not found
  IS_NOT_FOUND_ERROR,

  /// Method not allowed
  IS_METHOD_NOT_ALLOWED_ERROR,

  /// The request is not acceptable
  IS_NOT_ACCEPTABLE_ERROR,

  /// Request timeout
  IS_TIMEOUT_ERROR,

  /// Conflict on the server
  IS_CONFLICT_ERROR,

  /// Lengh required
  IS_LENGTH_REQUIRED_ERROR,

  /// Unprocessable
  IS_UNPROCESSABLE_ERROR,

  /// Too Many requests at the same time
  IS_TOO_MANY_REQUESTS_ERROR,

  /// General error
  IS_GENERAL_ERROR,

  /// The method is not implemented
  IS_NOT_IMPLEMENTED_ERROR,

  /// Bad gateway
  IS_BAD_GATE_WAY_ERROR,

  /// Server is unavailable
  IS_UNAVAILABLE_ERROR,

  // Cannot sent the request
  IS_CANNOT_SEND_REQUEST
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

/// Transforme error sent by feathers js to local error type
FeatherJsError errorCode2FeatherJsError(error) {
  var type;
  switch (error["code"]) {
    case 400:
      type = FeatherJsErrorType.IS_BAD_REQUEST_ERROR;
      break;
    case 401:
      type = FeatherJsErrorType.IS_NOT_AUTHENTICATED_ERROR;
      break;
    case 402:
      type = FeatherJsErrorType.IS_PAYMENT_ERROR;
      break;
    case 403:
      type = FeatherJsErrorType.IS_FORBIDDEN_ERROR;
      break;
    case 404:
      type = FeatherJsErrorType.IS_NOT_FOUND_ERROR;
      break;
    case 405:
      type = FeatherJsErrorType.IS_METHOD_NOT_ALLOWED_ERROR;
      break;
    case 406:
      type = FeatherJsErrorType.IS_NOT_ACCEPTABLE_ERROR;
      break;
    case 408:
      type = FeatherJsErrorType.IS_TIMEOUT_ERROR;
      break;
    case 409:
      type = FeatherJsErrorType.IS_CONFLICT_ERROR;
      break;
    case 411:
      type = FeatherJsErrorType.IS_LENGTH_REQUIRED_ERROR;
      break;
    case 422:
      type = FeatherJsErrorType.IS_UNPROCESSABLE_ERROR;
      break;
    case 429:
      type = FeatherJsErrorType.IS_TOO_MANY_REQUESTS_ERROR;
      break;
    case 500:
      type = FeatherJsErrorType.IS_GENERAL_ERROR;
      break;
    case 501:
      type = FeatherJsErrorType.IS_NOT_IMPLEMENTED_ERROR;
      break;
    case 502:
      type = FeatherJsErrorType.IS_BAD_GATE_WAY_ERROR;
      break;
    case 503:
      type = FeatherJsErrorType.IS_UNAVAILABLE_ERROR;
      break;
    default:
      type = FeatherJsErrorType.IS_SERVER_ERROR;
  }
  return new FeatherJsError(error: error, type: type);
}

/// Feathers Js realtime event data
class FeathersJsEventData<T> {
  FeathersJsEventType type;
  T data;
  FeathersJsEventData({this.type, this.data});
}

/// Feathers Js realtime event type
enum FeathersJsEventType { updated, patched, created, removed }
