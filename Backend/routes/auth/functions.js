const UserModel = require("../../models/user");
const { registerValidation, loginValidation } = require("./authValidations");
const userFirestoreCRUD = require("../../services/firestore/userFirestoreCRUD");

module.exports.register = async (req, res, next) => {
    // validate the given user info
    const validatedData = registerValidation(req.body);
    if (validatedData.error)
        return res
            .status(400)
            .json({ message: validatedData.error.details[0].message });

    // checks if username already exists
    try {
        const user = new UserModel(req.body);

        // check if username exists
        const usernameExists = await userFirestoreCRUD.getUserViaUsername(
            user.get_username()
        );
        if (usernameExists) {
            return res.status(400).json({ message: "username already exists" });
        }
        // check if email exists
        const emailExits = await userFirestoreCRUD.getUserViaEmail(
            user.get_email()
        );
        if (emailExits) {
            return res.status(400).json({ message: "email already exists" });
        }

        // create new user
        const userDoc = await userFirestoreCRUD.createUser(user.toMap());
        return res.json(userDoc.id);
    } catch (error) {
        return res
            .status(500)
            .json({ message: `Internal server error`, errorMessage: error });
    }
};

module.exports.login = async (req, res, next) => {
    // validate the given user info
    const validatedData = loginValidation(req.body);
    if (validatedData.error)
        return res
            .status(400)
            .json({ message: validatedData.error.details[0].message });

    try {
        const user = await userFirestoreCRUD.getUserViaUsername(
            req.body.username
        );
        return res.json(user);
    } catch (error) {
        return res
            .status(500)
            .json({ message: "Internal server error", errorMessage: error });
    }
};
