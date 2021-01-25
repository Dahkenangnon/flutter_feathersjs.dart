# Introduction

## :bird: flutter_feathersjs :bird:

Communicate with your feathers js [https://feathersjs.com/](https://feathersjs.com/) server from flutter.

`Infos: Feathers js is a node framework for real-time applications and REST APIs.`

*__FormData support out the box, auth, reAuth, socketio send event, rest ...__ 

## Illustration's service infos

In this documentation, we assume that our feathers js api has a **news** services register on **/news**

with the following schema

```js

 // News schema
  const schema = new Schema({

    title: { type: String, required: true },

    content: { type: String, required: true },

    // They can provide multiple image for a single news
    files: { type: Array, required: false },

    //The publisher id
    author: { type: Schema.Types.ObjectId, ref: 'users', required: true },

  }, {
    timestamps: true
  });
```

## The illustration's app

The app used for this documentation will be available very soon.