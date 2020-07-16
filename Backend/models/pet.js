//@ts-check

/**
 * Model to pets for creating
 * @param {*} param0
 * @returns Petmodel
 */
function Pet({ id, name, ownerId }) {
	// private variables
	let _pet_id = id;
	let _pet_name = name;
	let _owner_id = ownerId;
	let _animal_type = "";
	let _dob = "";

	/**
	 * returns the pet id
	 * @returns pet id of the model
	 */
	this.getPetId = () => {
		return _pet_id;
	};

	/**
	 * Getter of the pet model
	 * @returns pet name of the pet model instance
	 */
	this.getPetName = () => {
		return _pet_name;
	};

	/**
	 * Getter of the pet model
	 * @returns owner id of the pet model instance
	 */
	this.getOwnerId = () => {
		return _owner_id;
	};

	/**
	 * Getter of the pet model
	 * @returns animal type of the pet
	 */
	this.getAnimalType = () => {
		return _animal_type;
	};

	/**
	 * Getter of the pet model
	 * @returns date of birth of the pet
	 */
	this.getDOB = () => {
		return _dob;
	};

	// setter here

	/**
	 * setter for the pet id property
	 * @param {String} petId
	 */
	this.setPetId = (petId) => {
		_pet_id = petId;
	};

	/**
	 * setter for the pet name property
	 * @param {string} petName
	 */
	this.setPetName = (petName) => {
		_pet_name = petName;
	};

	/**
	 * setter for the owner id property
	 * @param {string} ownerId
	 */
	this.setOwnerId = (ownerId) => {
		_owner_id = ownerId;
	};

	/**
	 * setter for the animalType property
	 * @param {string} animalType
	 */
	this.setAnimalType = (animalType) => {
		_animal_type = animalType;
	};

	/**
	 * setter of the date of birth of the pet user
	 * @param {string} dob
	 */
	this.setDOB = (dob) => {
		_dob = dob;
	};

	/**
	 * Function which turns the object properties to map
	 * @returns map object with all properties
	 */
	this.toMap = () => {
		const map = {};
		if (_pet_id) {
			map["pet_id"] = _pet_id;
		}
		map["pet_name"] = _pet_name;
		map["owner_id"] = _owner_id;
		map["animal_type"] = _animal_type;
		map["dob"] = _dob;

		return map;
	};
}

/**
 * create the pet model instance from the firestore data object
 * @param {import("@google-cloud/firestore").DocumentData} mapData
 * @param {string} docId
 * @returns the pet instance created from the firestore data
 */
const PetFromFirestore = (mapData, docId) => {
	const pet_instance = new Pet({
		id: docId,
		name: mapData["pet_name"],
		ownerId: mapData["owner_id"],
	});

	pet_instance.setAnimalType(mapData["animal_type"]);
	pet_instance.setDOB(mapData["dob"]);
	return pet_instance;
};

module.exports = { PetModel: Pet, PetFromFirestore };
