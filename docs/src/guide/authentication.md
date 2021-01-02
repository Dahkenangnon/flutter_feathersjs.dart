# Authentication

Because we have two parts (scoketio and rest) which must communicate 
with the same server (which required maybe authentication) we must found a way to authenticate 
both rest & socketio once user is logged.

Below, how to authenticate rest only or socketio only. But notice that in a production app, 
you don't need to auth speratly the different client, just use the global authentication method.
Nice ? Go

## Auth rest

You can for testing purpose only authenticate the rest client by doing the following.
Note that when you use an other stratagy different from email/pass strategy, you must configure it on your server.

```dart
   // Auth with rest client with email/password [Default strategy]
   var authResponse = await flutterFeathersjs.rest
      .authenticate(userName: "mail@mail.com", password: "Strong_Pass");

    // Or

    // Auth with rest client with phone/password strategy
   var authResponse = await flutterFeathersjs.rest.authenticate(
      strategy: "phone",
      userNameFieldName: "tel",
      userName:"+22900000000",,
      password: "Strong_Pass");

```

## Auth socketio

The process to authenticate the socketio client is done after rest auth is os because,
it using the JWT retrieved by rest client when process finished with ok. 

```dart
  // Note: This must be call after rest auth success
  // Not recommanded to use this directly
  var authResponse = await flutterFeathersjs.scketio.authWithJWT();

```



## Global Auth (recommanded)

Definitely, this is what you must do when you want to authenticate your user.

```dart

/// ------ First time

// Auth globaly with phone number strategy
// When using this strategy: ensure you configure your feathers js server accordingly
 var rep = await flutterFeathersjs.authenticate(
      strategy: "phone",
      userNameFieldName: "tel",
      userName: "+22900000000",
      password: "Strong_Pass");




// Auth globaly with email  strategy [default]
 var rep = await flutterFeathersjs.authenticate(
      userName: "mail@mail.com",
      password: "Strong_Pass");

/// ------ On app restart or when JWT still validated
 var reps = await flutterFeathersjs.reAuthenticate();

    if (!reps["error"]) {
      print('client is authed');
      print("----------Authed user :------");
      print(reps["message"]); // User is under  reps["message"] when all thing is Ok
      print("----------Authed user :------");
    } else
    {
      print(reps["message"]); // Error message is under  reps["message"] when something is wrong

      // If you want to check when error is comming from socketio client
      // Error message from socketio client,
      print(reps["scketResponse"]);


       // If you want to check when error is comming from rest client
      // Error message from rest client,
      print(reps["restResponse"]);
    }
```