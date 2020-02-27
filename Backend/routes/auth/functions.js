const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const _ = require("lodash"); // for modifing the array contents

const { UserModel, UserfromFirestore } = require("../../models/user");
const { registerValidation, loginValidation } = require("./authValidations");
const userFirestoreCRUD = require("../../services/firestore/userFirestoreCRUD");

module.exports.register = async (req, res) => {
    // validate the given user info
    const validatedData = registerValidation(req.body);
    if (validatedData.error)
        return res
            .status(400)
            .json({ message: validatedData.error.details[0].message });

    // checks if username already exists
    try {
        const user = new UserModel({
            email: req.body.email,
            username: req.body.username,
            id: null
        });

        // check if username exists
        const usernameExists = await userFirestoreCRUD.getUserViaUsername(
            user.getUsername()
        );
        if (usernameExists) {
            return res.status(400).json({ message: "username already exists" });
        }
        // check if email exists
        const emailExits = await userFirestoreCRUD.getUserViaEmail(
            user.getEmail()
        );
        if (emailExits) {
            return res.status(400).json({ message: "email already exists" });
        }

        // hash the passwords
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(req.body.password, salt);
        user.setPassword(hashedPassword);

        // create new user
        const userDoc = await userFirestoreCRUD.createUser(user.toMap());

        // Assign a json web token
        const tokenSecret = process.env.Token_Secret;
        const jToken = jwt.sign({ id: userDoc.id }, tokenSecret, {
            expiresIn: "1d"
        });

        return res.header("authorization", jToken).json(jToken);
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: `Internal server error` });
    }
};

module.exports.login = async (req, res) => {
    // validate the given user info
    const validatedData = loginValidation(req.body);
    if (validatedData.error)
        return res
            .status(400)
            .json({ message: validatedData.error.details[0].message });

    try {
        let user = await userFirestoreCRUD.getUserViaUsername(
            req.body.username
        );

        user = user.data();
        // Check user password
        const validPassword = await bcrypt.compare(
            req.body.password,
            user.password
        );

        if (!validPassword)
            return res.status(400).json({ message: "Password is invalid" });

        // Assign a json web token
        const tokenSecret = process.env.Token_Secret;
        const jToken = jwt.sign({ id: user.id }, tokenSecret, {
            expiresIn: "1d"
        });

        user = UserfromFirestore({ mapData: user, docId: user.id });

        return res.header("authorization", jToken).json(user.toMap());
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};

module.exports.forgotPassword = async (req, res) => {
    // code to forgot password here
};

module.exports.getUser = async (req, res) => {
    return res.json({ user: req.loggedUser });
};

module.exports.sendEmailVerification = async (req, res) => {
    // code to send the email verification here
};

module.exports.verifyEmail = async (req, res) => {
    // code to verify email here
};

module.exports.resetPassword = async (req, res) => {
    // code to reset password here
};

module.exports.editUser = async (req, res) => {
    // code to edit user profile
};
