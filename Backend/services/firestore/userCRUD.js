const database = require("./database");

// reference to the collection
let coll_ref = database.collection("users");

// function to create a new user
module.exports.createUser = async userMap => {
    const new_uSer_ref = await coll_ref.add(userMap);
    return new_uSer_ref;
};

module.exports.updateUser = async userMap => {
    const user_doc = await coll_ref.doc(userMap["id"]).get();
    return user_doc;
};

// function to get user via email
module.exports.getUserViaEmail = async email => {
    let docs = await coll_ref.where("email", "==", email).get();
    if (docs.empty) return false;

    return docs.docs[0];
};

// function to get user via username
module.exports.getUserViaUsername = async username => {
    let docs = await coll_ref.where("username", "==", username).get();
    if (docs.empty) return false;

    return docs.docs[0];
};

module.exports.getUserViaID = async id => {
    let doc_ref = coll_ref.doc(id);
    return await doc_ref.get();
};
