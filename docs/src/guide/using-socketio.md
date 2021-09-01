# Socketio client

**Feathers Js scketio client for realtime communication**

You get exactly what feathers server send (_Serialization and Deserialization are not supported._) except in the listen method.

This client don't support file upload

Recommended: Use this client accross your app when file upload is not required

## find

Retrieves a list of all matching resources from the service

All message

```dart
     try {
       var messageResponse = await flutterFeathersjs.scketio.so(serviceName: "message",
       query: {});

       // print(messageResponse); => feathers's find data format
    } on FeatherJsError catch (e) {

      // When error is FeatherJsErrorType
      // if(e.type == FeatherJsErrorType.IS_SERVER_ERROR)
      // Check the error type as above and handle it
    } catch (er) {
      // Catch  unknown error

    }
```

message matching certain query

```dart

     try {
      // Find message with query: here with {"_id": "5f7643f0462f4348970cd32e"}
 var messageResponse = await flutterFeathersjs.scketio.find(serviceName: "message", query: {"_id": "5f7643f0462f4348970cd32e"});

       // print(messageResponse); => feathers's find data format
    } on FeatherJsError catch (e) {

      // When error is FeatherJsErrorType
      // if(e.type == FeatherJsErrorType.IS_SERVER_ERROR)
      // Check the error type as above and handle it
    } catch (er) {
      // Catch  unknown error

    }
```

## get

Retrieve a single resource from the service with an `_id`

```dart


     try {
      // Get a single new with it _id
 var messageResponse = await flutterFeathersjs.scketio.get(serviceName: "message", objectId: "5f7643f0462f4348970cd32e");

       // print(messageResponse); => feathers's get data format
    } on FeatherJsError catch (e) {

      // When error is FeatherJsErrorType
      // if(e.type == FeatherJsErrorType.IS_SERVER_ERROR)
      // Check the error type as above and handle it
    } catch (er) {
      // Catch  unknown error

    }
```

## create

Create a new resource with data.

```dart


    try {

   // Create a message on the server without file upload
      var messageResponse = await flutterFeathersjs.scketio.create(
        serviceName: "message",
        data: {"title": "Using FlutterFeathersjs is easy", "content": "Yes very easy" , "author" :"5f7h43f0462f4348970cd32e"});

       // print(messageResponse); => feathers's get data format
    } on FeatherJsError catch (e) {

      // When error is FeatherJsErrorType
      // if(e.type == FeatherJsErrorType.IS_SERVER_ERROR)
      // Check the error type as above and handle it
    } catch (er) {
      // Catch  unknown error

    }
```

## update

Completely replace a single resource with the `_id = objectId`

```dart

    try {

     var messageResponse = await flutterFeathersjs.scketio.update(
        objectId: "5f7h43f0462f4t48970cd32e",
        serviceName: "message",
        data: {"title": "Using FlutterFeathersjs is easy", "content": "Yes very easy" , "author" :"5f7h43f0462f4348970cd32e"});

       // print(messageResponse); => feathers's get data format
    } on FeatherJsError catch (e) {

      // When error is FeatherJsErrorType
      // if(e.type == FeatherJsErrorType.IS_SERVER_ERROR)
      // Check the error type as above and handle it
    } catch (er) {
      // Catch  unknown error

    }
```

## patch

Completely replace a single resource with the `_id = objectId`

```dart
 try {

    var messageResponse = await flutterFeathersjs.scketio.patch(
        objectId: "5f7h43f0462f4t48970cd32e",
        serviceName: "message",
        data: {"title": "Using FlutterFeathersjs is easy", "content": "Yes very easy" , "author" :"5f7h43f0462f4348970cd32e"});
       // print(messageResponse); => feathers's get data format
    } on FeatherJsError catch (e) {

      // When error is FeatherJsErrorType
      // if(e.type == FeatherJsErrorType.IS_SERVER_ERROR)
      // Check the error type as above and handle it
    } catch (er) {
      // Catch  unknown error

    }
```

## remove

Remove a single resource with `_id = objectId`:

```dart
try {
    var messageResponse = await flutterFeathersjs.scketio.remove(serviceName: "message", objectId: "5f7643f0462f4348970cd32e");

       // print(messageResponse); => feathers's remove data format
    } on FeatherJsError catch (e) {

      // When error is FeatherJsErrorType
      // if(e.type == FeatherJsErrorType.IS_SERVER_ERROR)
      // Check the error type as above and handle it
    } catch (er) {
      // Catch  unknown error

    }
```

## listen  :zzz:

For realtime event listening, keep in mind these informations:

0. `On updated | patched | created | removed` event are all supported;
1. You need a [StreamSubscription](https://api.flutter.dev/flutter/dart-async/StreamSubscription-class.html)
2. You need a state manangment plugin like [flutter_bloc](https://pub.dev/packages/flutter_bloc)

Now assume that we want to listen to `On created` on `message` service in realtime

Add an event in your `message_event.dart`:

```dart

class FeatherCreatedMessageEvent extends MessageEvent {
  final Message message;

  FeatherCreatedMessageEvent({@required this.message});

  @override
  List<Object> get props => [message];
}

```

Add a state in your `message_state.dart`:

```dart
class FeatherCreatedMessageState extends MessageState {
  final String message;

  FeatherCreatedMessageState({@required this.message});

  @override
  List<Object> get props => [message];
}

```

Now listen the event and broadcast it to your widget in your `message_bloc.dart`:

```dart

import 'dart:async';
import 'package:flutter_feathersjs/src/helper.dart';

// Other required import

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {

  // FlutterFeathersjs
  final FlutterFeathersjs flutterFeathersjs;

  // StreamSubscription
  StreamSubscription streamSubscription;


  // MessageBloc constructor
  MessageBloc(
      {this.flutterFeathersjs})
      : super(MessageInitial()) {

    // Listen to realtime event
    streamSubscription = flutterFeathersjs.scketio
        .listen<Message>(
            serviceName: "message",
            fromJson: Message.fromMap)
        .listen(

            // onData:
            (event) {

        // event is FeathersJsEventData<Message>
        // What event is sent by feathers js ?
        if(event.type == FeathersJsEventType.created){
            // Trigger flutter_bloc event
            add(FeatherCreatedMessageEvent(message: event));

        }else if(event.type == FeathersJsEventType.removed){
            // 
        } else if (event.type == FeathersJsEventType.patched){
            // ...
        }
      
    },


     // onError:
    onError: (e) {
    // e is a FeatherJsError
    // You can check what error occured: e.type
     
     // Add the event to flutter_bloc
      add(MessageError(message: e.error));
    },

    );
  }

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    try {

        // Listen to flutter_bloc event which correspond to our case for realtime 
      if (event is FeatherCreatedMessageEvent) {
        
        // Change the state to allow ui update 
        yield FeatherCreatedMessageState(message: event.message);
      }
    } catch (e) {
      //yield MessageError(message: "Error");
    }
  }

  //This method should be called when a [Bloc] is no longer needed.
  // Just add it, nothing to customize except the streamSubscription var name 
  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}

```
