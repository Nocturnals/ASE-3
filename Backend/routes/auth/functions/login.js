//@ts-check

const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken"); // for modifing the array contents

const { UserfromFirestore } = require("../../../models/user");

const { loginValidation } = require("../authValidations");

const userCRUD = require("../../../services/firestore/userCRUD");

module.exports = async (req, res) => {
    // validate the given user info
    const validatedData = loginValidation(req.body);
    if (validatedData.error)
        return res
            .status(400)
            .json({ message: validatedData.error.details[0].message });

    try {
        let user = await userCRUD.getUserViaUsername(req.body.username);

        const userData = user.data();
        // Check user password
        const validPassword = await bcrypt.compare(
            req.body.password,
            userData.password
        );

        if (!validPassword)
            return res.status(400).json({ message: "Password is invalid" });

        if (process.env.NODE_ENV !== "development") {
            if (!userData.email_verified) {
                return res
                    .status(401)
                    .json({ message: "Access denied as email isn't verified" });
            }
        }

        // Assign a json web token
        const tokenSecret = process.env.Token_Secret;
        const jToken = jwt.sign({ id: user.id }, tokenSecret, {
            expiresIn: "1d",
        });
        console.log(jToken);

        const user_instance = UserfromFirestore({
            mapData: userData,
            docId: user.id,
        });

        return res
            .header("authorization", jToken)
            .json({ user: user_instance.toMap() });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
