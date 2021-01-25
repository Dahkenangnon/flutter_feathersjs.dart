# Rest methods

**__Feathers Js rest client for rest api call__**

You get exactly what feathers server send (*Serialization and Deserialization are not supported.*)
You can get the response sent by feathers js by: response.data
When required, to access the data property of feathers response, you have to do: response.data.data

## find

Retrieves a list of all matching resources from the service

All news

```dart
    // Find all news
 var newsResponse = await flutterFeathersjs.rest.find(serviceName: "news");
    print(newsResponse.data);
```

News matching certain query

```dart
    // Find news with query: here with {"_id": "5f7643f0462f4348970cd32e"}
 var newsResponse = await flutterFeathersjs.rest.find(serviceName: "news", query: {"_id": "5f7643f0462f4348970cd32e"});
    print(newsResponse.data);
```

## get

Retrieve a single resource from the service with an `_id`

```dart
    // Get a single new with it _id
 var newsResponse = await flutterFeathersjs.rest.get(serviceName: "news", objectId: "5f7643f0462f4348970cd32e");
    print(newsResponse.data);
```

## create

Create a new resource with data.

Without files

```dart
    // Create a news on the server without file upload
var newsResponse = await flutterFeathersjs.rest.create(
        serviceName: "news",
        data: {"title": "Using FlutterFeathersjs is easy", "content": "Yes very easy" , "author" :"5f7h43f0462f4348970cd32e"});
```

With files

```dart
    // Create a news on the server with file upload
    // For this, it is your responsability to configure your feathers js to handle 
    // file upload, see multer for example

    //1.  Afther picking filed from devices, ensure you have  a list of File object as:
var files = [{ 'filePath': '/data/shared/image.png', 'fileName': 'image.png' },
      { 'filePath': '/data/shared/image.png', 'fileName': 'image.png' }];

    //2. Send data with files
var newsResponse = await flutterFeathersjs.rest.create(
        serviceName: "news",
        data: {"title": "Using FlutterFeathersjs is easy even with file upload", "content": "Yes very easy" , "author" :"5f7h43f0462f4348970cd32e"},
        containsFile = true, 
        fileFieldName = "files", // See the news schema. This is the same string
        );
```

## update

Completely replace a single resource with the `_id = objectId`

Without files

```dart
    // Update a news on the server without file upload
var newsResponse = await flutterFeathersjs.rest.update(
        objectId: "5f7h43f0462f4t48970cd32e",
        serviceName: "news",
        data: {"title": "Using FlutterFeathersjs is easy", "content": "Yes very easy" , "author" :"5f7h43f0462f4348970cd32e"});
```

With files

```dart
    // Create a news on the server with file upload
    // For this, it is your responsability to configure your feathers js to handle 
    // file upload, see multer

    //1.  Afther picking file from devices, ensure you have  a list of File object as:
var files = [{ 'filePath': '/data/shared/image.png', 'fileName': 'image.png' },
      { 'filePath': '/data/shared/image.png', 'fileName': 'image.png' }];

    //2. Send data with file
var newsResponse = await flutterFeathersjs.rest.update(
  objectId: "5f7h43f0462f4t48970cd32e",
        serviceName: "news",
        data: {"title": "Using FlutterFeathersjs is easy even with file upload", "content": "Yes very easy" , "author" :"5f7h43f0462f4348970cd32e"},
        containsFile = true, 
      fileFieldName = "files", // See the news schema. This is the same string
        );
```

## patch

Completely replace a single resource with the `_id = objectId`

Without files

```dart
    // Patch a new on the server without file upload
var newsResponse = await flutterFeathersjs.rest.patch(
        objectId: "5f7h43f0462f4t48970cd32e",
        serviceName: "news",
        data: {"title": "Using FlutterFeathersjs is easy", "content": "Yes very easy" , "author" :"5f7h43f0462f4348970cd32e"});
```

With files

```dart
    // Patch a news on the server with file upload
    // For this, it is your responsability to configure your feathers js to handle 
    // file upload, see multer

    //1.  Afther picking file from devices, ensure you have  a list of File object as:
var files = [{ 'filePath': '/data/shared/image.png', 'fileName': 'image.png' },
      { 'filePath': '/data/shared/image.png', 'fileName': 'image.png' }];

    //2. Send data with file
var newsResponse = await flutterFeathersjs.rest.patch(
  objectId: "5f7h43f0462f4t48970cd32e",
        serviceName: "news",
        data: {"title": "Using FlutterFeathersjs is easy even with file upload", "content": "Yes very easy" , "author" :"5f7h43f0462f4348970cd32e"},
        containsFile = true, 
      fileFieldName = "files", // See the news schema. This is the same string
        );
```

## remove

 Remove a single  resource with `_id = objectId`:

```dart
    // Remove a news
var newsResponse = await flutterFeathersjs.rest.remove(serviceName: "news", objectId: "5f7643f0462f4348970cd32e");
```
