//@ts-check

const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const { UserModel } = require("../../../models/user");

const { sendEmailToVerifyEmail } = require("../helper");
const { registerValidation } = require("../authValidations");

const userCRUD = require("../../../services/firestore/userCRUD");

module.exports = async (req, res) => {
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
            id: null,
        });

        // check if username exists
        const usernameExists = await userCRUD.getUserViaUsername(
            user.getUsername()
        );
        if (usernameExists) {
            return res.status(400).json({ message: "username already exists" });
        }
        // check if email exists
        const emailExits = await userCRUD.getUserViaEmail(user.getEmail());
        if (emailExits) {
            return res.status(400).json({ message: "email already exists" });
        }

        // hash the passwords
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(req.body.password, salt);
        await user.setPassword(hashedPassword);

        // create new user
        const userDoc = await userCRUD.createUser(user.toMap());
        await user.setId(userDoc.id);

        await user.setPublic_to([userDoc.id]);

        // Assign a json web token
        const tokenSecret = process.env.Token_Secret;
        const jToken = jwt.sign({ id: user.getId() }, tokenSecret, {
            expiresIn: "1d",
        });

        await sendEmailToVerifyEmail(user);

        return res.header("authorization", jToken).json(jToken);
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
