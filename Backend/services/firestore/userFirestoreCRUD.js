const database = require("./database");

module.exports.createUser = async userMap => {
    let collRef = database.collection("users");
    const newUSerRef = await collRef.add(userMap);
    return newUSerRef;
};

// function to get user via email
module.exports.getUserViaEmail = async email => {
    let collRef = database.collection("users");
    let docs = await collRef.where("email", "==", email).get();
    if (docs.empty) return false;

    return docs.docs[0];
};

// function to get user via username
module.exports.getUserViaUsername = async username => {
    let collRef = database.collection("users");
    let docs = await collRef.where("username", "==", username).get();
    if (docs.empty) return false;

    return docs.docs[0];
};
