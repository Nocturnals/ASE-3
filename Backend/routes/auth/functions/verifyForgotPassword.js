const bcrypt = require("bcryptjs");

const { UserfromFirestore } = require("../../../models/user");
const {
    ForgotPasswordFromFirestore,
} = require("../../../models/forgotPassword");

const { verifyForgotPasswordValidation } = require("../authValidations");

const userCRUD = require("../../../services/firestore/userCRUD");
const forgotPasswordCRUD = require("../../../services/firestore/forgotPasswordCRUD");

module.exports = async (req, res) => {
    // validate the input data
    const validateData = verifyForgotPasswordValidation(req.body);
    if (validateData.error) {
        return res
            .status(400)
            .json({ message: validateData.error.details[0].message });
    }

    try {
        // get the user details
        const user_doc = await userCRUD.getUserViaEmail(req.body.email);
        if (!user_doc.exists) {
            return res.status(400).json({ message: "invalid email address" });
        }
        const user = UserfromFirestore({
            mapData: user_doc.data(),
            docId: user_doc.id,
        });

        // check for the forgor password doc data
        const forgot_password_doc = await forgotPasswordCRUD.getForgotPasswordViaId(
            user.getId()
        );
        if (!forgot_password_doc.exists) {
            return res
                .status(401)
                .json({ message: "Didn't yet appy for forgot password" });
        }
        const forgot_password_instance = ForgotPasswordFromFirestore({
            mapData: forgot_password_doc.data(),
            docId: forgot_password_doc.id,
        });

        // check if the secret code
        if (forgot_password_instance.getSecret_code() == req.body.secret_code) {
            // check if it is expired
            if (new Date().getDate() > forgot_password_instance.getDeadline()) {
                return res.status(400).json({ message: "Code has expired" });
            }

            // change the pass word and save to database
            // hash the passwords
            const salt = await bcrypt.genSalt(10);
            const hashedPassword = await bcrypt.hash(req.body.password, salt);
            user.setPassword(hashedPassword);

            // update the database
            const newUser = await userCRUD.updateUser(user.toMap());
            // delete the forgot password instance
            await forgotPasswordCRUD.deleteDoc(forgot_password_doc.id);

            return res
                .status(200)
                .json({ message: "successully changed password" });
        } else {
            return res.status(400).json({ message: "Invalid code" });
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
