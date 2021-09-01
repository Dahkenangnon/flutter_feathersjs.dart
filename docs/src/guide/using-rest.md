# Rest Client

**Feathers Js rest client for rest api call**

You get exactly what feathers server send (_Serialization and Deserialization are not supported._)

## find

Retrieves a list of all matching ressources from the service

All message

```dart
     try {
       var messageResponse = await flutterFeathersjs.rest.find(serviceName: "message",
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
 var messageResponse = await flutterFeathersjs.rest.find(serviceName: "message", query: {"_id": "5f7643f0462f4348970cd32e"});

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
 var messageResponse = await flutterFeathersjs.rest.get(serviceName: "message", objectId: "5f7643f0462f4348970cd32e");

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

Without files

```dart


    try {

   // Create a message on the server without file upload
      var messageResponse = await flutterFeathersjs.rest.create(
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

With files

Create a message on the server with file upload
For this, it is your responsability to configure your feathers js to handle
file upload, see multer for example

```dart

    //1.  Afther picking files from devices, ensure you have  a list of File object as:
    var files = [{ 'filePath': '/data/shared/image.png', 'fileName': 'image.png' },
      { 'filePath': '/data/shared/image.png', 'fileName': 'image.png' }];

    //2. Send data with files


    try {

       var messageResponse = await flutterFeathersjs.rest.create(
        serviceName: "message",
        data: {"title": "Using FlutterFeathersjs is easy even with file upload", "content": "Yes very easy" , "author" :"5f7h43f0462f4348970cd32e"},
        containsFile = true,
        fileFieldName = "files", // mongoose field to store the file name
        );

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

Without files
Update a message on the server without file upload

```dart

    try {

     var messageResponse = await flutterFeathersjs.rest.update(
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

With files

Create a message on the server with file upload
For this, it is your responsability to configure your feathers js to handle
file upload, see multer

```dart
    //1.  Afther picking file from devices, ensure you have  a list of File object as:
    var files = [{ 'filePath': '/data/shared/image.png', 'fileName': 'image.png' },
      { 'filePath': '/data/shared/image.png', 'fileName': 'image.png' }];


          try {

    //2. Send data with file
    var messageResponse = await flutterFeathersjs.rest.update(
        objectId: "5f7h43f0462f4t48970cd32e",
        serviceName: "message",
        data: {"title": "Using FlutterFeathersjs is easy even with file upload", "content": "Yes very easy" , "author" :"5f7h43f0462f4348970cd32e"},
        containsFile = true,
      fileFieldName = "files",
        );

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

Without files
Patch a new on the server without file upload

```dart
 try {

    var messageResponse = await flutterFeathersjs.rest.patch(
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

With files

```dart
    // Patch a message on the server with file upload
    // For this, it is your responsability to configure your feathers js to handle
    // file upload, see multer

    //1.  Afther picking file from devices, ensure you have  a list of File object as:
var files = [{ 'filePath': '/data/shared/image.png', 'fileName': 'image.png' },
      { 'filePath': '/data/shared/image.png', 'fileName': 'image.png' }];


 try {

       //2. Send data with file
    var messageResponse = await flutterFeathersjs.rest.patch(
        objectId: "5f7h43f0462f4t48970cd32e",
        serviceName: "message",
        data: {"title": "Using FlutterFeathersjs is easy even with file upload", "content": "Yes very easy" , "author" :"5f7h43f0462f4348970cd32e"},
        containsFile = true,
      fileFieldName = "files",
        );
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
    var messageResponse = await flutterFeathersjs.rest.remove(serviceName: "message", objectId: "5f7643f0462f4348970cd32e");

       // print(messageResponse); => feathers's remove data format
    } on FeatherJsError catch (e) {

      // When error is FeatherJsErrorType
      // if(e.type == FeatherJsErrorType.IS_SERVER_ERROR)
      // Check the error type as above and handle it
    } catch (er) {
      // Catch  unknown error

    }
```
