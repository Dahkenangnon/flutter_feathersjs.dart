//Help FlutterFeathersJs
import 'dart:async';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class Utils {
  /////////////////////////////////////////////////////////////////////
  // File path to a file in the current directory
  String dbPath = 'flutter_feathersjs.db';
  DatabaseFactory dbFactory = databaseFactoryIo;
  Database db;

  ////////////////////////////////////////////////////////////////////////

  Utils();

//Allow to set rest access token
  Future<bool> setAccessToken({String token}) async {
    //Open th db
    db = await dbFactory.openDatabase(dbPath);
    var store = StoreRef.main();
    return await store.record('feathersjs_access_token').put(db, token);
  }

//Allow to get rest access token
  Future<String> getAccessToken({String token}) async {
    //Open db
    db = await dbFactory.openDatabase(dbPath);
    var store = StoreRef.main();
    //Get token from it
    return await store.record('feathersjs_access_token').get(db) as String;
  }
}
