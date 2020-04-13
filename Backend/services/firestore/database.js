//@ts-check

// import firebase admin
const admin = require("firebase-admin");

// secret service private key
let service_account = require("../../pet-social.json");

admin.initializeApp({
    //@ts-ignore
    credential: admin.credential.cert(service_account),
    databaseURL: "https://pet-social-cd55d.firebaseio.com",
});

// instance of the firestore database
let db = admin.firestore();

module.exports = db;
