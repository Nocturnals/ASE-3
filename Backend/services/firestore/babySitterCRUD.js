//@ts-check

const database = require("./database");

// reference to the collection
let coll_ref = database.collection("babySitter");

module.exports.createbabySitter = async (babySitterMap) => {
    const new_babySitter_ref = await coll_ref.add(babySitterMap);
    return new_babySitter_ref;
};

module.exports.updatebabySitter = async (babySitterMap) => {
    const update_babySitter_ref = await coll_ref
        .doc(babySitterMap["babysitter_id"])
        .update(babySitterMap);
    return update_babySitter_ref;
};

module.exports.deletebabySitter = async (id) => {
    return await coll_ref.doc(id).delete();
};

module.exports.getbabySitterViaId = async (id) => {
    const get_babySitter = await coll_ref.doc(id).get();
    return get_babySitter;
};
