import 'package:flutter_test/flutter_test.dart';

import 'package:feathersjs/feathersjs.dart';

void main() {
  ///Fixtures
  Map<String, String> fixtures = {
    "strategy": "local",
    "email": "hi@marro.com",
    "password": "supersecret"
  };

  const BASE_URL = "http://localhost:3030/";

  ////////////////////////////////////////////////////
  ///
  ///             Feathers Js class test
  ////////////////////////////////////////////////////

  //Singleton pattern if the FeathersJs class
  /* 
  test('Testing singleton ', () {
    FeathersJs feathersJs1 = FeathersJs();
    FeathersJs feathersJs2 = FeathersJs();
    expect(identical(feathersJs1, feathersJs2), true);
  });
 

  //Testing the authentication method
  test('Authentication method', () async {
    FeathersJs feathersJs = FeathersJs();
    feathersJs.init(baseUrl: BASE_URL);
    var rep = await feathersJs.authenticate(
        strategy: fixtures['strategy'],
        email: fixtures['email'],
        password: fixtures['password']);
    print(rep["msg"]);
    expect(rep["error"], false);
  });
  */

  ////////////////////////////////////////////////////
  ///
  ///             Rest client test
  ////////////////////////////////////////////////////

/*
  //Testing the authentication method
  test('FIn all method', () async {
    FeathersJs feathersJs = FeathersJs();
    feathersJs.init(baseUrl: BASE_URL);
    var rep = await feathersJs.authenticate(
        strategy: fixtures['strategy'],
        email: fixtures['email'],
        password: fixtures['password']);
    var rep2 = await feathersJs.restClient.find(serviceName: "news");
    print("\n  ____________ data ____________ \n");
    print(rep2.data);
    print("\n ____________ data ____________ \n");
  });


  test('FIn with with query params', () async {
    FeathersJs feathersJs = FeathersJs();
    feathersJs.init(baseUrl: BASE_URL);
    var rep = await feathersJs.authenticate(
        strategy: fixtures['strategy'],
        email: fixtures['email'],
        password: fixtures['password']);

    var rep2 = await feathersJs.restClient
        .find(serviceName: "news", query: {"_id": "YlrVkFWo0oYoH3A3"});
    print("\n  ____________ data ____________ \n");
    print(rep2.data);
    print("\n ____________ data ____________ \n");
  });



  test('Rest get method', () async {
    FeathersJs feathersJs = FeathersJs();
    feathersJs.init(baseUrl: BASE_URL);
    var rep = await feathersJs.authenticate(
        strategy: fixtures['strategy'],
        email: fixtures['email'],
        password: fixtures['password']);

    var rep2 = await feathersJs.restClient
        .get(serviceName: "news", objectId: "YlrVkFWo0oYoH3A3");
    print("\n  ____________ data ____________ \n");
    print(rep2.data);
    print("\n ____________ data ____________ \n");
  });
*/

/*
  test('Create method', () async {
    FeathersJs feathersJs = FeathersJs();
    feathersJs.init(baseUrl: BASE_URL);
    var rep = await feathersJs.authenticate(
        strategy: fixtures['strategy'],
        email: fixtures['email'],
        password: fixtures['password']);

    var rep2 = await feathersJs.restClient.create(
        serviceName: "news",
        data: {"title": "Bieen sur tout ira bien", "content": "LE meilleur que tu cherche est très proche"});
   print("\n  ____________ data ____________ \n");
    print(rep2.data);
    print("\n ____________ data ____________ \n");
  });
*/
/*
  test('update method', () async {
    FeathersJs feathersJs = FeathersJs();
    feathersJs.init(baseUrl: BASE_URL);
    var rep = await feathersJs.authenticate(
        strategy: fixtures['strategy'],
        email: fixtures['email'],
        password: fixtures['password']);

    var rep2 = await feathersJs.restClient.update(
        serviceName: "news",
        objectId: "K9YU85bWki6isp0N",
        data: {"title": "Un nouveau titre", "content": "Un nouveau contenu"});
    print("\n  ____________ data ____________ \n");
    print(rep2.data);
    print("\n ____________ data ____________ \n");
  });
*/
/* 
  test('findd method', () async {
    FeathersJs feathersJs = FeathersJs();
    feathersJs.init(baseUrl: BASE_URL);
    var auth = await feathersJs.authenticate(
        email: fixtures['email'],
        password: fixtures['password'],
        client: 'all');
    if (auth) {
      var rep2 = await feathersJs.socketioClient.emitFind(
        serviceName: "users",
      );
      print("\n  ____________ data ____________ \n");
      print(rep2);
      print("\n ____________ data ____________ \n");
    } else {
      print("Auth error");
    }
  }); */

  ////////////////////////////////////////////////////
  ///
  ///             Socketio client test
  ////////////////////////////////////////////////////

  /*  test('___Testing all authentication___', () async {
    var i = 1;
    var n = 10000000;
    displ(data) {
      print("____ \n");
      print(data);
      print("___\n");
    }

    while (i <= n) {
      i++;
      print("In the loop");
      var feathersJs = FeathersJs();
      await feathersJs.init(baseUrl: BASE_URL);
      var isAuthSocket = await feathersJs.authenticate(
          email: fixtures['email'],
          password: fixtures['password'],
          client: 'all');
      if (isAuthSocket) {
        feathersJs.socketioClient
            .onRemoved(serviceName: "users", callback: displ);
      } else {
        print('Auth failed');
      }
    }
  }); */
}
