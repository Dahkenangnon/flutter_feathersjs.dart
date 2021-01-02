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

- Fix

## 0.0.5-dev

- Fix const error

## 0.0.4-dev

- Fix const error

## 0.0.3-dev

- Change sembast dependencies to shared_preferences as sembast cause "OS Error: Read-only file system, errno = 30 in flutter"

## 0.0.2-dev

- Add auth and reAuth for both rest and socketio client
- Add socketio methods
- Test socketio emit methods
- Add global auth and reAuth which don't matter whatever you're calling via socketio or rest

## 0.0.1-dev

- Initial version
- Not for production use. It still under dev
