//@ts-check

const { PetModel, PetFromFirestore } = require("../../../models/pet");
const petCRUD = require("../../../services/firestore/petCRUD");
const userCRUD = require("../../../services/firestore/userCRUD");

const Validation = require("../petValidations");

/**
 * fucntion to register a new pet into the user
 * @param {import("express").Request} req
 * @param {import("express").Response} res
 * @param {import("express").NextFunction} next
 */
module.exports = async (req, res, next) => {
	// validate the given user info
	const validatedData = Validation.registerValidation(req.body);
	if (validatedData.error)
		return res
			.status(400)
			.json({ message: validatedData.error.details[0].message });

	// try to create a new instance of the pet
	try {
		// instance of the pet
		const pet = new PetModel({
			id: null,
			name: req.body.petName,
			//@ts-ignore
			ownerId: req.loggedUser.getId(),
		});
		pet.setAnimalType(req.body.animalType);
		pet.setDOB(req.body.dob);

		// save the pet data to firestore database
		let pet_doc = await petCRUD.createPet(pet.toMap());

		// ADD THE PET TO THE USER DATA
		// increment the count of pets
		// @ts-ignore
		let loggedUser = req.loggedUser;
		loggedUser.setPets_count(loggedUser.getPets_count() + 1);

		// set the pet id in pets list
		let pets_ids = loggedUser.getPet_ids();
		pets_ids.push(pet_doc.id);
		loggedUser.setPet_ids(pets_ids);
		//@ts-ignore
		req.loggedUser = loggedUser;

		// save the changed user details in the database
		await userCRUD.updateUser(loggedUser.toMap());
		return res
			.status(200)
			.json({ message: "successfully registered new pet" });
	} catch (error) {
		console.log(error);
		return res.status(500).json({ message: "Internal server error" });
	}
};
