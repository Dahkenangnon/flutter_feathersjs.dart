// Default access token storage key name
const String FEATHERSJS_ACCESS_TOKEN = "FEATHERSJS_ACCESS_TOKEN";
// Access token storage key for standalone rest client
const String FEATHERSJS_REST_ACCESS_TOKEN = "FEATHERSJS_REST_ACCESS_TOKEN";
// Access token storage key name for standalone socketio client
const String FEATHERSJS_SOCKETIO_ACCESS_TOKEN =
    "FEATHERSJS_SOCKETIO_ACCESS_TOKEN";
// The authenticated user storage key name
const FEATHERSJS_USER = "FEATHERSJS_USER";

/// FeatherJsErrorType
enum FeatherJsErrorType {
  /// This error come from  your feathers js server
  IS_SERVER_ERROR,

  /// This error come from any FlutterFeathersjs.rest's method
  IS_REST_ERROR,

  /// This error come from any FlutterFeathersjs.scketio's method
  IS_SOCKETIO_ERROR,

  /// Error when deserializing realtime object in socketio listen method
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

  /// See https://docs.feathersjs.com/api/errors.html#feathers-errors
  /// Bad request
  IS_BAD_REQUEST_ERROR,

  /// Client not authenticated
  IS_NOT_AUTHENTICATED_ERROR,

  /// PaymentError
  IS_PAYMENT_ERROR,

  /// Access denied
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

  /// Cannot sent the request
  IS_CANNOT_SEND_REQUEST,

  /// Standalone feathers js client configuration error
  CONFIGURATION_ERROR,

  /// Dart error
  IS_DART_ERROR
}
