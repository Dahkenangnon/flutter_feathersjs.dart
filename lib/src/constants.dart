class Constants {
  static const String INVALID_CREDENTIALS = "INVALID_CREDENTIALS";
  static const String JWT_EXPIRED_ERROR = "JWT_EXPIRED_ERROR";
  static const String NO_ERROR = "NO_ERROR";
  static const String UNKNOWN_ERROR = "UNKNOWN_ERROR";
  static const String JWT_ERROR = "JWT_ERROR";
  static const String JWT_NOT_FOUND = "JWT_NOT_FOUND";
  static const String INVALID_STRATEGY = "INVALID_STRATEGY";
  static const String DIO_ERROR = "DIO_ERROR";

  static const String AUTH_WITH_JWT_SUCCEED = "AUTH_WITH_JWT_SUCCEED";
  static const String AUTH_WITH_JWT_FAILED = "AUTH_WITH_JWT_FAILED";

  static const String BOTH_CLIENT_AUTHED = "BOTH_CLIENT_AUTHED";
  static const String ONE_OR_BOTH_CLIENT_NOT_AUTHED =
      "ONE_OR_BOTH_CLIENT_NOT_AUTHED";
}

class Removed<T> {}

class Patched<T> {}

class Created<T> {}

class Updated<T> {}

class Connected {}

class DisConnected {}
