import 'constants.dart';

/// Socketio Connected
class Connected {}

/// Socketio Disconnected
class DisConnected {}

/// FeatherJsError describes the error info  when request failed.
class FeatherJsError implements Exception {
  FeatherJsError({
    this.type = FeatherJsErrorType.IS_UNKNOWN_ERROR,
    this.error,
  });

  FeatherJsErrorType type;

  dynamic error;

  StackTrace? _stackTrace;

  // ignore: unnecessary_getters_setters
  set stackTrace(StackTrace? stack) => _stackTrace = stack;

  // ignore: unnecessary_getters_setters
  StackTrace? get stackTrace => _stackTrace;

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

/// Transform error sent by feathers js to local error type
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
  FeathersJsEventType? type;
  T? data;
  FeathersJsEventData({this.type, this.data});
}

/// Feathers Js realtime event type
enum FeathersJsEventType { updated, patched, created, removed }
