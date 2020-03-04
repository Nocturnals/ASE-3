const database = require("./database");

// reference to the collection
let coll_ref = database.collection("forgotpassword");

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
