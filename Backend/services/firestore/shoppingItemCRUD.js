const database = require("./database");

// reference to the collection
let coll_ref = database.collection("shoppingItem");

module.exports.createshoppingItem = async shoppingItemMap => {
    const new_shoppingItem_ref = await coll_ref.add(shoppingItemMap);
    return new_shoppingItem_ref;
};

module.exports.updateshoppingItem = async shoppingItemMap =>{
    const update_shoppingItem_ref = await coll_ref.doc(shoppingItemMap["shoppingitem_id"]).update(shoppingItemMap);
    return update_shoppingItem_ref;
};

module.exports.deleteshoppingItem = async id =>{
    return await coll_ref.doc(id).delete();
};

module.exports.getshoppingItemViaId = async id =>{
    const get_shoppingItem = await coll_ref.doc(id).get();
    return get_shoppingItem;
};
