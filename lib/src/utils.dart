//Help FlutterFeathersJs
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  /////////////////////////////////////////////////////////////////////
  SharedPreferences prefs;

  ////////////////////////////////////////////////////////////////////////

  Utils();

//Allow to set rest access token
  Future<bool> setAccessToken({String token}) async {
    prefs = await SharedPreferences.getInstance();

    return await prefs.setString('feathersjs_access_token', token);
  }

//Allow to get rest access token
  Future<String> getAccessToken({String token}) async {
    prefs = await SharedPreferences.getInstance();
    return await prefs.getString('feathersjs_access_token');
  }
}
