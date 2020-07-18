// @ts-check

const { AddressFromFirestore } = require("../../../models/address");
const { BabySitterModel } = require("../../../models/babySitter");
const babySitterCRUD = require("../../../services/firestore/babySitterCRUD");

const Validation = require("../babySitterValidations");

/**
 * The fuction to register an user as a baby sitter for pets
 * @param {import("express").Request} req 
 * @param {import("express").Response} res 
 * @param {import("express").NextFunction} next 
 */
module.exports = async (req, res, next) => {
    // validate the body format
    const validatedData = Validation.registerValidation(req.body);
    if (validatedData.error)
        return res
            .status(400)
            .json({ message: validatedData.error.details[0].message });

    // try to register the user as baby sitter
    try {
        // create instance of the address
        const address = AddressFromFirestore(req.body.address);
        // const address = new AddressModel();
        // address.setLane(req.body.address.lane);
        // address.setStreet(req.body.address.street);
        // address.setCity(req.body.address.city);
        // address.setState(req.body.address.state);
        // address.setCountry(req.body.address.country);
        // address.setPostalCode(req.body.address.postal_code);

        // create the instance of the babysitter 
        // @ts-ignore
        const babysitter = new BabySitterModel({ id: req.loggedUser.getId() });
        babysitter.setAddress(address.toMap());
        babysitter.setContact_no(req.body.contact_no);

        // update the data in the database
        const babysitterDoc = await babySitterCRUD.createbabySitter(babysitter.toMap());
        return res.json({ message: "successfully registered as babysitter" });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
