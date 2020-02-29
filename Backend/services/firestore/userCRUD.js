const database = require("./database");

module.exports.createUser = async userMap => {
    let coll_ref = database.collection("users");
    const new_uSer_ref = await coll_ref.add(userMap);
    return new_uSer_ref;
};

// function to get user via email
module.exports.getUserViaEmail = async email => {
    let coll_ref = database.collection("users");
    let docs = await coll_ref.where("email", "==", email).get();
    if (docs.empty) return false;

    return docs.docs[0];
};

// function to get user via username
module.exports.getUserViaUsername = async username => {
    let coll_ref = database.collection("users");
    let docs = await coll_ref.where("username", "==", username).get();
    if (docs.empty) return false;

    return docs.docs[0];
};

module.exports.getUserViaID = async id => {
    let doc_ref = database.collection("users").doc(id);
    return await doc_ref.get();
};
