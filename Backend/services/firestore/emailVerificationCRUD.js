const database = require("./database");

// reference to the collection
let coll_ref = database.collection("emailverifications");

module.exports.createEmailVerification = async map => {
    // if already exists
    const old_doc = await coll_ref.doc(map["id"]).get();
    if (old_doc.exists) {
        await coll_ref.doc(map["id"]).update(map);
    } else {
        await coll_ref.doc(map["id"]).create(map);
    }

    return;
};

module.exports.getEmailVerificationViaId = async id => {
    // get the id doc
    const doc = await coll_ref.doc(id).get();
    return doc;
};
