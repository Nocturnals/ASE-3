//@ts-check

/**
 * Model to pets for creating
 * @param {*} param0
 * @returns Petmodel
 */
function Pet({ id, name, ownerId }) {
	// private variables
	let _pet_id = id;
	const _pet_name = name;
	const _owner_id = ownerId;
	let _animal_type = "";
	let _dob = "";

	/**
	 * returns the pet id
	 * @returns pet id of the model
	 */
	this.getPetId = () => {
		return this._pet_id;
	};

	/**
	 * Getter of the pet model
	 * @returns pet name of the pet model instance
	 */
	this.getPetName = () => {
		return this._pet_name;
	};

	/**
	 * Getter of the pet model
	 * @returns owner id of the pet model instance
	 */
	this.getOwnerId = () => {
		return this._owner_id;
	};

	/**
	 * Getter of the pet model
	 * @returns animal type of the pet
	 */
	this.getAnimalType = () => {
		return this._animal_type;
	};

	/**
	 * Getter of the pet model
	 * @returns date of birth of the pet
	 */
	this.getDOB = () => {
		return this._dob;
	};

	// setter here

	/**
	 * setter for the pet id property
	 * @param {String} petId
	 */
	this.setPetId = (petId) => {
		this._pet_id = petId;
	};

	/**
	 * setter for the pet name property
	 * @param {string} petName
	 */
	this.setPetName = (petName) => {
		this._pet_name = petName;
	};

	/**
	 * setter for the owner id property
	 * @param {string} ownerId
	 */
	this.setOwnerId = (ownerId) => {
		this._owner_id = ownerId;
	};

	/**
	 * setter for the animalType property
	 * @param {string} animalType
	 */
	this.setAnimalType = (animalType) => {
		this._animal_type = animalType;
	};

	/**
	 * setter of the date of birth of the pet user
	 * @param {string} dob
	 */
	this.setDOB = (dob) => {
		this._dob = dob;
	};

	/**
	 * Function which turns the object properties to map
	 * @returns map object with all properties
	 */
	this.toMap = () => {
		const map = {};
		if (this._pet_id) {
			map["pet_id"] = this._pet_id;
		}
		map["pet_name"] = this._pet_name;
		map["owner_id"] = this._owner_id;
		map["animal_type"] = this._animal_type;
		map["dob"] = this._dob;

		return map;
	};
}

/**
 * create the pet model instance from the firestore data object
 * @param {Map<any, any>} mapData
 * @param {string} docId
 */
const PetFromFirestore = (mapData, docId) => {
	const pet_instance = new Pet({
		id: docId,
		name: mapData["pet_name"],
		ownerId: mapData["owner_id"],
	});

	pet_instance.setAnimalType(mapData["animal_type"]);
	pet_instance.setDOB(mapData["dob"]);
};

module.exports = { PetModel: Pet, PetFromFirestore };
