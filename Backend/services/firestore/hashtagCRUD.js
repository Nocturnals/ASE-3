//@ts-check

const database = require("./database");

// reference to the collection
let coll_ref = database.collection("Hashtags");

module.exports.createHashtag = async (hashtagMap) => {
    const new_hashtag_ref = await coll_ref.add(hashtagMap);
    return new_hashtag_ref;
};

module.exports.updateHashtag = async (hashtagMap) => {
    const updated_hashtag_ref = await coll_ref
        .doc(hashtagMap["id"])
        .update(hashtagMap);
    return updated_hashtag_ref;
};

module.exports.deleteHashtag = async (id) => {
    return await coll_ref.doc(id).delete();
};

module.exports.getHashtagViaId = async (id) => {
    const doc_ref = await coll_ref.doc(id);
    return doc_ref.get();
};

module.exports.getHashtagViaName = async (hashtag_name) => {
    const docs = await coll_ref.where("hashtag_name", "==", hashtag_name).get();
    if (docs.empty) return null;

    return docs.docs[0];
};

module.exports.getAll = async () => {
    const docs = await coll_ref.get();
    return docs;
};
