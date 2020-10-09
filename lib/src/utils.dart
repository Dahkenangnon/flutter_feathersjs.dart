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
  Future<bool> setRestAccessToken({String token}) async {
    //Open th db
    db = await dbFactory.openDatabase(dbPath);
    var store = StoreRef.main();
    //Put token it it
    return await store.record('rest_access_token').put(db, token);
  }

//Allow to get rest access token
  Future<String> getRestAccessToken({String token}) async {
    //Open db
    db = await dbFactory.openDatabase(dbPath);
    var store = StoreRef.main();
    //Get token from it
    return await store.record('rest_access_token').get(db) as String;
  }

  //Allow to set socketio access token
  Future<bool> setSocketAccessToken({String token}) async {
    //Open th db
    db = await dbFactory.openDatabase(dbPath);
    var store = StoreRef.main();
    //Put token it it
    return await store.record('socket_access_token').put(db, token);
  }

//Allow to get socketio access token
  Future<String> getSocketAccessToken({String token}) async {
    //Open db
    db = await dbFactory.openDatabase(dbPath);
    var store = StoreRef.main();
    //Get token from it
    return await store.record('socket_access_token').get(db) as String;
  }

  //Allow to set the authenticated from feathers js server
  Future<bool> setAuthenticatedFeathersUser({Map<String, dynamic> user}) async {
    //Open th db
    db = await dbFactory.openDatabase(dbPath);
    var store = StoreRef.main();
    return await store.record('feathers_authenticated_user').put(db, user);
  }

//Allow to get  the authenticated from feathers js server
  Future<Map<String, dynamic>> getAuthenticatedFeathersUser() async {
    //Open db
    db = await dbFactory.openDatabase(dbPath);
    var store = StoreRef.main();
    return await store.record('feathers_authenticated_user').get(db)
        as Map<String, dynamic>;
  }
}
