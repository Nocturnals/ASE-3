const database = require("./database");

// reference to the collection
let coll_ref = database.collection("animaladoption");

module.exports.createanimalAdoption = async animalAdoptionMap => {
    const new_animalAdoption_ref = await coll_ref.add(animalAdoptionMap);
    return new_animalAdoption_ref;
};

module.exports.updateanimalAdoption = async animalAdoptionMap =>{
    const update_animalAdoption_ref = await coll_ref.doc(animalAdoptionMap["animal_adoption_id"]).update(animalAdoptionMap);
    return update_animalAdoption_ref;
};

module.exports.deleteanimalAdoption = async id =>{
    return await coll_ref.doc(id).delete();
};

module.exports.getanimalAdoptionViaId = async id =>{
    const get_animalAdoption = await coll_ref.doc(id).get();
    return get_animalAdoption;
};

// module.exports.getanimalAdoptionViaUserId = async id =>{
//     const get_animalAdoption = await coll_ref.where("user_id", "==", id).get();
//     if (get_animalAdoption) return false;

//     return get_animalAdoption
// }