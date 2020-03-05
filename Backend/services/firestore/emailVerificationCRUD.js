const database = require("./database");

// reference to the collection
let coll_ref = database.collection("emailverifications");

// function to create email verification modal doc
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

// function to get doc via id
module.exports.getEmailVerificationViaId = async id => {
    // get the id doc
    const doc = await coll_ref.doc(id).get();
    return doc;
};

// fucntion to delete a doc
module.exports.deleteDoc = async id => {
    return await coll_ref.doc(id).delete();
};
