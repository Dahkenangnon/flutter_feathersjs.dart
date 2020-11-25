//Help FlutterFeathersJs
import 'dart:async';

import 'package:flutter_feathersjs/src/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  SharedPreferences prefs;
  Utils();

  /// Store JWT for reAuth() purpose
  Future<bool> setAccessToken({String token}) async {
    prefs = await SharedPreferences.getInstance();

    return await prefs.setString(Constants.FEATHERSJS_ACCESS_TOKEN, token);
  }

  /// Get the early stored JWT for reAuth() purpose
  Future<String> getAccessToken({String token}) async {
    prefs = await SharedPreferences.getInstance();
    return await prefs.getString(Constants.FEATHERSJS_ACCESS_TOKEN);
  }
}
