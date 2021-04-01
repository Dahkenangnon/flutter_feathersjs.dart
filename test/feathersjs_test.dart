import 'package:flutter_feathersjs/src/constants.dart';
import 'package:flutter_feathersjs/src/rest_client.dart';
import 'package:flutter_feathersjs/src/scketio_client.dart';
import 'package:flutter_feathersjs/src/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_feathersjs/flutter_feathersjs.dart';

//Fixtures contains sample data for processing test with a feathers js client
import 'fixtures.dart';

void main() async {
  ////////////////////////////////////////////////////
  ///
  ///             Create single FlutterFeatherJs instance
  ///
  ////////////////////////////////////////////////////
  //Global FlutterFeatherJs client
  FlutterFeathersjs flutterFeathersjs = FlutterFeathersjs()
    ..init(baseUrl: BASE_URL);

  ////////////////////////////////////////////////////
  ///
  ///          Auth or reAuth
  ///
  ////////////////////////////////////////////////////
  // // Authenticate user  and comment this line
  //

  try {
    // var rep = await flutterFeathersjs.authenticate(
    //     //     // strategy: "phone",
    //     //     // userNameFieldName: "tel",
    //     userName: user["email"],
    //     password: user["password"]);
    var rep = await flutterFeathersjs.reAuthenticate();
    print("Auth user is");
    print(rep);
  } on FeatherJsError catch (e) {
    if (e.type == FeatherJsErrorType.IS_INVALID_CREDENTIALS_ERROR) {
      print("Invalid credentials");
    } else if (e.type == FeatherJsErrorType.IS_INVALID_STRATEGY_ERROR) {
      print("Invalid STRA");
    } else if (e.type == FeatherJsErrorType.IS_AUTH_FAILED_ERROR) {
      print("IS_AUTH_FAILED_ERROR");
    } else {
      print(e.type);
      print(e.message);
    }
  }

  // //Then use this one to reuse access token as it still valide
  //var reAuthResp = await flutterFeathersjs.reAuthenticate();

  // print("Auth user is");
  // print(rep);

  // print("ReAuth is");
  // print(reAuthResp);

  // print("Hello");
  // ////////////////////////////////////////////////////
  // ///
  // ///          Singleton testing
  // ///
  // ////////////////////////////////////////////////////

  // // // Singleton pattern if the flutterFeathersjs class
  // test('Testing singleton ', () {
  //   FlutterFeathersjs flutterFeathersjs1 = FlutterFeathersjs();
  //   expect(identical(flutterFeathersjs1, flutterFeathersjs), true);
  // });

  // // // ////////////////////////////////////////////////////
  // // // ///
  // // // ///             reAuth
  // // // ////////////////////////////////////////////////////

  // // //Testing the authentication method
  // test(' reAuthentication method', () async {
  //   var reps = await flutterFeathersjs.reAuthenticate();
  //   if (!reps["error"]) {
  //     print('client is authed');
  //     print("----------Authed user :------");
  //     print(reps["message"]);
  //     print("----------Authed user :------");
  //   } else if (reps["error_zone"] == Constants.BOTH_CLIENT_AUTHED)
  //     print("Blabal");
  //   else {
  //     print(reps["error_zone"]);
  //     print(reps["message"]);
  //     print("frm secktio");
  //     print(reps["scketResponse"]);
  //     print("frm rest");
  //     print(reps["restResponse"]);
  //   }
  // });

  // // // ////////////////////////////////////////////////////
  // // // ///
  // // // ///            Rest client methods
  // // // ///
  // // // ///////////////////////////////////////////////////

  // test('Testing singleton on Rest client', () {
  //   RestClient so1 = RestClient()..init(baseUrl: BASE_URL);
  //   RestClient so2 = RestClient()..init(baseUrl: BASE_URL);
  //   if (so1 == so2) {
  //     print("so1 ==  so2");
  //   }
  //   expect(identical(so1, so2), true);
  // });

  test(' \n rest Find all method  \n', () async {
    try {
      var rep2 =
          await flutterFeathersjs.rest.find(serviceName: "users", query: {});
      print("\n  Founds news are: \n");
      print(rep2);
    } on FeatherJsError catch (e) {
      print("Error");
      print(e.type);
      print(e.message);
    } catch (er) {
      print("Other error");
      print(er);
    }
  });

  // test(' \n rest find with with query params \n ', () async {
  //   var rep2 = await flutterFeathersjs.rest.find(
  //       serviceName: "v1/news", query: {"_id": "5f7643f0462f4348970cd32e"});
  //   print("\n The news _id: 5f7643f0462f4348970cd32e is: \n");
  //   print(rep2.data);
  // });

  // test(' \n Rest get method  \n', () async {
  //   var rep2 = await flutterFeathersjs.rest
  //       .get(serviceName: "v1/news", objectId: "5f7643f0462f4348970cd32e");
  //   print("\n The news _id: 5f7643f0462f4348970cd32e is: \n");
  //   print(rep2.data);
  // });

  // test(' \n Rest Create method with user service \n ', () async {
  //   try {
  //     var rep2 = await flutterFeathersjs.scketio.create(
  //         serviceName: "users",
  //         data: {"email": user["email"], "password": user["password"]});
  //     print("\n  The newly created user is: \n");
  //     print(rep2);
  //   } on FeatherJsError catch (e) {
  //     // Catch error from feahters js
  //     //
  //     if (e.type == FeatherJsErrorType.IS_SERVER_ERROR) {
  //       print("Error is from feathers js api server");
  //     } else if (e.type == FeatherJsErrorType.IS_REST_ERROR) {
  //       print("Error is from rest methods");
  //     } else if (e.type == FeatherJsErrorType.IS_SOCKETIO_ERROR) {
  //       print("from socketio error");
  //     } else {
  //       print("incconnu error");
  //       print(e.type);
  //     }
  //     print(e.message);
  //   } catch (e) {
  //     print("Last ca");
  //     print(e.message);
  //   }
  // });

  // test(' \n Rest create news with image (FormData support testing) \n ',
  //     () async {
  //   var data2Send = {
  //     "title": "formdata testing",
  //     "content": "yo",
  //     "by": "5f9aceba20bc3d3a74b7bf8b",
  //     "enterprise": "5f9acf4f20bc3d3a74b7bf91"
  //   };

  //   var files = [
  //     {"filePath": "spin.PNG", "fileName": "spin.PNG"}
  //   ];

  //   var rep2 = await flutterFeathersjs.rest.create(
  //       serviceName: "v1/news",
  //       data: data2Send,
  //       containsFile: true,
  //       fileFieldName: "file",
  //       files: files);
  //   print("\n  The new news menu created  is: \n");
  //   print(rep2.data);
  // });

  // //////////////////////////////////////////////////
  // ///
  // ///            Scketio client methods
  // ///
  // /////////////////////////////////////////////////

  // test('Testing singleton on socketioClient', () {
  //   SocketioClient so1 = SocketioClient()..init(baseUrl: BASE_URL);
  //   SocketioClient so2 = SocketioClient()..init(baseUrl: BASE_URL);
  //   if (so1 == so2) {
  //     print("so1 ==  so2");
  //   }
  //   expect(identical(so1, so2), true);
  // });

  // //Testing the authentication with jwt method
  // test('socketio reAuthentication method', () async {
  //   var repss = await flutterFeathersjs.scketio.authWithJWT();

  //   //print(reps);

  //   if (!repss["error"]) {
  //     print('client is authed');
  //     print(repss["message"]);
  //     print(repss["error_zone"]);
  //   } else {
  //     print(repss["message"]);
  //     print(repss["error_zone"]);
  //   }
  // });

  // test('find method', () async {
  //   var rep2 = await flutterFeathersjs.scketio.find(
  //     query: {},
  //     serviceName: "v1/news",
  //   );
  //   print("Printing news:");
  //   print(rep2);
  // });
}
