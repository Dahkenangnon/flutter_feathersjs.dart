## 4.0.4+1 - Add documentation in pubspec.yaml and 
## 4.0.4 - Fix [Authentication Breaking Due to Casting Error on Future](https://github.com/Dahkenangnon/flutter_feathersjs.dart/issues/22)

## 4.0.3 - Improve documentation


## 4.0.2 - Nullsafety


## 4.0.1-dev.nullsafety - Remove meta from pubspec

## 4.0.0-dev.nullsafety - Migrating to null-safety

## 3.0.0 - Error handling and new features

See [the release information](https://github.com/Dahkenangnon/flutter_feathersjs.dart/releases/tag/V3.0.0)

## 2.0.3-dev
## 2.0.2-dev
## 2.0.1-dev
## 2.0.0-dev
Upgrading to nullsafety
## 1.0.10
Fix [overwhelming debug's message ouputing in production](https://github.com/Dahkenangnon/flutter_feathersjs.dart/discussions/6#discussion-2051014)
## 1.0.9

Documentation is now available from: [https://dahkenangnon.github.io/flutter_feathersjs.dart/](https://dahkenangnon.github.io/flutter_feathersjs.dart/)

## 1.0.8-dev
## 1.0.7-dev
## 1.0.6-dev
## 1.0.5-dev
## 1.0.4-dev
## 1.0.3-dev
## 1.0.2-dev
## 1.0.1-dev
## 1.0.0

- Improvment: Documentation of the code
- Breaking: on both rest and socketio, you get exactly what feathers js send,  we don't support any serializer or deserializer. So how previous version handle data is breaken
- Feature: Add event listen but not fully tested
- Authentication don't matter if you auth user with email/password. You can use email/password, phone/password, userName/password
- Feature: support now phone, email, etc, with password authentication

## 0.0.7

- remove unused comment
- Add formData handling 
- Update readme

## 0.0.6-dev


## 0.0.5-dev

## 0.0.4-dev

## 0.0.3-dev

- Change sembast dependencies to shared_preferences as sembast cause "OS Error: Read-only file system, errno = 30 in flutter"

## 0.0.2-dev

- Add auth and reAuth for both rest and socketio client
- Add socketio methods
- Test socketio emit methods
- Add global auth and reAuth which don't matter whatever you're calling via socketio or rest

## 0.0.1-dev

- Initial version
- Not for production use. 
- It still under dev
