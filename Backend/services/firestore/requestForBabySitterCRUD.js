const database = require("./database");

// reference to the collection
let coll_ref = database.collection("requestforbabysitting");

module.exports.createRequestBabySitter = async requestBabySitterMap => {
    const new_requestBabySitter_ref = await coll_ref.add(requestBabySitterMap);
    return new_requestBabySitter_ref;
};

module.exports.updateRequestBabySitter = async requestBabySitterMap => {
    const update_requestBabySitter_ref = await coll_ref
        .doc(requestBabySitterMap["request_for_babysitting_id"])
        .update(requestBabySitterMap);
    return update_requestBabySitter_ref;
};

module.exports.deleteRequestBabySitter = async id => {
    return await coll_ref.doc(id).delete();
};

module.exports.getRequestBabySitterViaId = async id => {
    const get_requestBabySitter = await coll_ref.doc(id).get();
    return get_requestBabySitter;
};

module.exports.getRequestBabySitterViaUserId = async id => {
    const get_requestBabySitter = await coll_ref
        .where("request_user_id", "==", id)
        .get();
    if (get_requestBabySitter) return false;

    return get_requestBabySitter;
};
