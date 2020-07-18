//@ts-check

const { PetFromFirestore } = require("../../../models/pet");
const petCRUD = require("../../../services/firestore/petCRUD");

/**
 * Function to get all the pets of a registered user
 * @param {import("express").Request} req
 * @param {import("express").Response} res
 * @param {import("express").NextFunction} next
 */
module.exports = async (req, res, next) => {
    try {
        // get the all pets of the user
        // @ts-ignore
        const petsArr = req.loggedUser.getPet_ids();
        const petsDocList = [];
        for (let index = 0; index < petsArr.length; index++) {
            const petId = petsArr[index];
            const doc = await petCRUD.getPetViaId(petId);
            const pet = PetFromFirestore(doc.data(), doc.id);
            petsDocList.push(pet.toMap());
        }

        return res.json({ "petsList": petsDocList });
    } catch (error) {
        console.log(error);
        res.status(400).json({ "message": "Internal server error" });
    }
};