const database = require("./database");

module.exports.createEmailVerification = async map => {
    let coll_ref = database.collection("emailverifications");

    // if already exists
    const old_doc = await coll_ref.doc(map["id"]).get();
    if (old_doc.exists) {
        await coll_ref.doc(map["id"]).update(map);
    } else {
        await coll_ref.doc(map["id"]).create(map);
    }

    return;
};
