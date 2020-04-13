//@ts-check

const database = require("./database");

// reference to the collection
let coll_ref = database.collection("order");

module.exports.createOrder = async (orderMap) => {
    const new_order_ref = await coll_ref.add(orderMap);
    return new_order_ref;
};

module.exports.updateOrder = async (orderMap) => {
    const update_order_ref = await coll_ref
        .doc(orderMap["order_id"])
        .update(orderMap);
    return update_order_ref;
};

module.exports.deleteOrder = async (id) => {
    return await coll_ref.doc(id).delete();
};

module.exports.getOrderViaId = async (id) => {
    const get_order = await coll_ref.doc(id).get();
    return get_order;
};

module.exports.getOrderViaItemId = async (id) => {
    const get_order = await coll_ref.where("item_id", "==", id).get();
    if (get_order) return false;

    return get_order;
};
