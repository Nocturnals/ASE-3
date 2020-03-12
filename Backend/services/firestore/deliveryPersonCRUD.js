const database = require("./database");

// reference to the collection
let coll_ref = database.collection("deliveryPerson");

module.exports.createDelivery = async deliveryMap => {
    const new_delivery_ref = await coll_ref.add(deliveryMap);
    return new_delivery_ref;
};

module.exports.updateDelivery = async deliveryMap =>{
    const update_delivery_ref = await coll_ref.doc(deliveryMap["deliveryPerson_id"]).update(deliveryMap);
    return update_delivery_ref;
};

module.exports.deleteDelivery = async id =>{
    return await coll_ref.doc(id).delete();
};

module.exports.getDeliveryViaId = async id =>{
    const get_delivery = await coll_ref.doc(id).get();
    return get_delivery;
};

module.exports.getDeliveryViaUserId = async id =>{
    const get_delivery = await coll_ref.where("user_id", "==", id).get();
    if (get_delivery) return false;

    return get_delivery
}