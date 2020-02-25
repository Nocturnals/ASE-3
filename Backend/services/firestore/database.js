// import firebase admin
const admin = require("firebase-admin");

// secret service private key
let service_account = require("../../pet-social.json");

admin.initializeApp({
    credential: admin.credential.cert(service_account)
});

// instance of the firestore database
let db = admin.firestore();

module.exports = db;
