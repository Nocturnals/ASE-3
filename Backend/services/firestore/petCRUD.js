//@ts-check

const database = require("./database");

/**
 * Reference to the collection pets
 */
let coll_ref = database.collection("pets");

/**
 * function to create a new pet
 * @param {object} petMap
 */
module.exports.createPet = async (petMap) => {
	const new_pet_ref = await coll_ref.add(petMap);
	return new_pet_ref;
};

/**
 * function to update the
 * @param {Map<any, any>} petMap
 */
module.exports.updatePet = async (petMap) => {
	const pet_doc = await coll_ref.doc(petMap["pet_id"]).update(petMap);
	return pet_doc;
};

/**
 * function to get pet via pet id
 * @param {string} petId
 */
module.exports.getPetViaId = async (petId) => {
	let doc_ref = coll_ref.doc(petId);
	return await doc_ref.get();
};
