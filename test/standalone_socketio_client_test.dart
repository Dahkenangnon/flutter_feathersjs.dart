// // ignore_for_file: avoid_init_to_null
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_feathersjs/flutter_feathersjs.dart';
// import 'fixtures.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// void main() async {
//   var idToGet = null;
//   var idToDelete = null;
//   var idToUpdate = null;

//   var messages = [
//     {"text": "Message to delete"},
//     {"text": "Message to update"},
//     {"text": "Message to get"},
//   ];

//   FlutterFeathersjs client = FlutterFeathersjs();

  
//   //2.1. Socket.io client
//   IO.Socket io = IO.io(BASE_URL,
//    {
//     'transports': ['websocket'],
//       'extraHeaders': {
//         'auth-demo': authDemo,
//       },
//       'autoConnect':
//           true, // Socketio will reconnect automatically when connection is lost
//    }
//   );


//   client.configure(FlutterFeathersjs.socketioClient(io));



//   /// ----------- Authentication -------------
//   test(' \n ### Authenticate user using default client \n ', () async {
//     var response = await client.authenticate(
//         userNameFieldName: 'email',
//         strategy: "local",
//         userName: user["email"],
//         password: user["password"]);
    
//     expect(response["email"], equals(user['email']));
//   });

//   /// Test "message" service creation
//   /// The created message will be deleted in the end of the test
//   test(' \n ### Create a message[for deletion] using rest standalone \n ',
//       () async {
//     var response =
//         await client.service('message').create({"text": messages[0]["text"]});
//     idToDelete = response['_id'];
   
//     expect(response["text"], equals(messages[0]["text"]));
//   });

//   /// Test "message" service creation
//   /// The created message will be deleted in the end of the test
//   test(' \n Create a message[for update] using rest standalone  \n ', () async {
//     var response =
//         await client.service('message').create({"text": messages[1]["text"]});
    
//     idToUpdate = response['_id'];
   
//     expect(response["text"], equals(messages[1]["text"]));
//   });

//   /// Test "message" service creation
//   /// The created message will be deleted in the end of the test
//   test(' \n Create a message[for get] using rest standalone  \n ', () async {
//     var response =
//         await client.service('message').create({"text": messages[2]["text"]});

//     idToGet = response['_id'];

//     expect(response["text"], equals(messages[2]["text"]));
//   });

//   // delete message
//   test(' \n Deleting $idToDelete using rest standalone  \n ', () async {
//     var response = await client.service('message').remove(idToDelete);

//     expect(response["text"], equals(messages[0]["text"]));
//   });

//   // update message
//   test(' \n Updating $idToUpdate using rest standalone  \n ', () async {
//     var response = await client
//         .service('message')
//         .patch(idToUpdate, {"text": "${messages[1]["text"]} updated"});
   
//     expect(response["text"], equals("${messages[1]["text"]} updated"));
//   });

//   // update message
//   test(' \n Getting $idToGet using rest standalone  \n ', () async {
//     var response = await client.service('message').get(idToGet);

//     expect(response['text'], equals(messages[2]["text"]));
//   });

//   // find message
//   test(' \n Find a message using rest standalone \n ', () async {
//     var response = await client.service('message').find({"_id": idToGet});

//     expect(response["data"][0]["text"], equals(messages[2]["text"]));
//   });
// }
void main() async {
}