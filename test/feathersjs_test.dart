import 'package:flutter_feathersjs/src/constants.dart';
import 'package:flutter_feathersjs/src/rest_client.dart';
import 'package:flutter_feathersjs/src/scketio_client.dart';
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
  // Authenticate user  and comment this line
  var rep = await flutterFeathersjs.rest
      .authenticate(email: user["email"], password: user["password"]);
  //Then use this one to reuse access token as it still valide
  //var reAuthResp = await flutterFeathersjs.rest.reAuthenticate();

  // //////////////////////////////////////////////////
  // /
  // /          Singleton testing
  // /
  // //////////////////////////////////////////////////

  //Singleton pattern if the flutterFeathersjs class
  test('Testing singleton ', () {
    FlutterFeathersjs flutterFeathersjs1 = FlutterFeathersjs();
    expect(identical(flutterFeathersjs1, flutterFeathersjs), true);
  });

  ////////////////////////////////////////////////////
  ///
  ///             reAuth
  ////////////////////////////////////////////////////

  //Testing the authentication method
  test(' reAuthentication method', () async {
    var reps = await flutterFeathersjs.reAuthenticate();
    if (!reps["error"]) {
      print('client is authed');
      print("----------Authed user :------");
      print(reps["message"]);
      print("----------Authed user :------");
    } else if (reps["error_zone"] == Constants.BOTH_CLIENT_AUTHED)
      print("Blabal");
    else {
      print(reps["error_zone"]);
      print(reps["message"]);
      print("frm secktio");
      print(reps["scketResponse"]);
      print("frm rest");
      print(reps["restResponse"]);
    }
  });

  ////////////////////////////////////////////////////
  ///
  ///            Rest client methods
  ///
  ///////////////////////////////////////////////////

  test('Testing singleton on Rest client', () {
    RestClient so1 = RestClient()..init(baseUrl: BASE_URL);
    RestClient so2 = RestClient()..init(baseUrl: BASE_URL);
    if (so1 == so2) {
      print("so1 ==  so2");
    }
    expect(identical(so1, so2), true);
  });

  test(' \n rest Find all method  \n', () async {
    var rep2 = await flutterFeathersjs.rest.find(serviceName: "v1/news");
    print("\n  Founds news are: \n");
    print(rep2.data);
  });

  test(' \n rest find with with query params \n ', () async {
    var rep2 = await flutterFeathersjs.rest.find(
        serviceName: "v1/news", query: {"_id": "5f7643f0462f4348970cd32e"});
    print("\n The news _id: 5f7643f0462f4348970cd32e is: \n");
    print(rep2.data);
  });

  test(' \n Rest get method  \n', () async {
    var rep2 = await flutterFeathersjs.rest
        .get(serviceName: "v1/news", objectId: "5f7643f0462f4348970cd32e");
    print("\n The news _id: 5f7643f0462f4348970cd32e is: \n");
    print(rep2.data);
  });

  test(' \n Rest Create method with user service \n ', () async {
    var rep2 = await flutterFeathersjs.rest.create(
        serviceName: "users",
        data: {"email": "user@email.com", "password": "password"});
    print("\n  The newly created user is: \n");
    print(rep2.data);
  });

  //////////////////////////////////////////////////
  //
  //            Scketio client methods
  //
  /////////////////////////////////////////////////

  test('Testing singleton on socketioClient', () {
    SocketioClient so1 = SocketioClient()..init(baseUrl: BASE_URL);
    SocketioClient so2 = SocketioClient()..init(baseUrl: BASE_URL);
    if (so1 == so2) {
      print("so1 ==  so2");
    }
    expect(identical(so1, so2), true);
  });

  //Testing the authentication with jwt method
  test('socketio reAuthentication method', () async {
    //SocketioClient socketioClient = new SocketioClient(baseUrl: BASE_URL);

    // var reps = await flutterFeathersjs.scketio
    //     .authenticate(email: user['email'], password: user["password"]);
    var repss = await flutterFeathersjs.scketio.authWithJWT();

    //print(reps);

    if (!repss["error"]) {
      print('client is authed');
      print(repss["message"]);
      print(repss["error_zone"]);
    } else {
      print(repss["message"]);
      print(repss["error_zone"]);
    }
  });

  test('find method', () async {
    var rep2 = await flutterFeathersjs.scketio.find(
      serviceName: "v1/news",
    );
    print("Printing news:");
    print(rep2);
  });
}
