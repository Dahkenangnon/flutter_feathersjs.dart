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
  FlutterFeathersjs flutterFeathersjs = FlutterFeathersjs();
  flutterFeathersjs.config(baseUrl: BASE_URL);

  ////////////////////////////////////////////////////
  ///
  ///          Auth or reAuth
  ///
  ////////////////////////////////////////////////////
  //Authenticate user  and comment this line
  var rep = await flutterFeathersjs.rest
      .authenticate(email: user["email"], password: user["password"]);
  //Then use this one to reuse access token as it still valide
  var reAuthResp = await flutterFeathersjs.rest.reAuthenticate();

  ////////////////////////////////////////////////////
  ///
  ///          Singleton testing
  ///
  ////////////////////////////////////////////////////

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
  test('rest reAuthentication method', () async {
    var reps = await flutterFeathersjs.rest.reAuthenticate();
    if (!reps["error"]) {
      print('client is authed');
    } else {
      print(reps["message"]);
      print(reps["error_zone"]);
    }
  });

  ////////////////////////////////////////////////////
  ///
  ///            Rest client methods
  ///
  ///////////////////////////////////////////////////

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
}
