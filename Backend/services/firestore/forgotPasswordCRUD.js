const database = require("./database");

// reference to the collection
let coll_ref = database.collection("forgotpassword");

// function to create a new forgot password doc
module.exports.createForgotPassord = async map => {
    // if already exists
    const old_doc = await coll_ref.doc(map["id"]).get();
    if (old_doc.exists) {
        await coll_ref.doc(map["id"]).update(map);
    } else {
        await coll_ref.doc(map["id"]).create(map);
    }

    return;
};

// fucntion to get forgot password via id
module.exports.getForgotPasswordViaId = async id => {
    const doc = await coll_ref.doc(id).get();
    return doc;
};

// fucntion to delete a doc via id
module.exports.deleteDoc = async id => {
    return await coll_ref.doc(id).delete();
};
