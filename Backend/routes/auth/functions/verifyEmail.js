//@ts-check

const { UserfromFirestore } = require("../../../models/user");
const {
    EmailVerificationFromFirestore,
} = require("../../../models/emailVerification");

const { verifyEmailValidation } = require("../authValidations");

const userCRUD = require("../../../services/firestore/userCRUD");
const emailVerificationCRUD = require("../../../services/firestore/emailVerificationCRUD");

module.exports = async (req, res) => {
    // validate the input data
    const validateData = verifyEmailValidation(req.body);
    if (validateData.error) {
        return res
            .status(400)
            .json({ message: validateData.error.details[0].message });
    }

    try {
        // get the user email verification mail
        let email_verification_doc = await emailVerificationCRUD.getEmailVerificationViaId(
            req.loggedUser.getId()
        );

        // check if the doc exists
        if (!email_verification_doc.exists) {
            return res
                .status(401)
                .json({ message: "First apply email verification form" });
        }

        let emailVerificationInstance = EmailVerificationFromFirestore({
            mapData: email_verification_doc.data(),
            docId: email_verification_doc.id,
        });

        // check if the secret code matches
        if (
            req.body.secret_code == emailVerificationInstance.getSecret_code()
        ) {
            // check if the code is expired
            if (
                emailVerificationInstance.getDeadline() < new Date().getDate()
            ) {
                return res.status(400).json({ message: "Code has expired" });
            }

            // verify the email
            req.loggedUser.setEmail_verified(true);
            const newUserDoc = await userCRUD.updateUser(
                req.loggedUser.toMap()
            );
            const newUser = UserfromFirestore({
                mapData: newUserDoc.data(),
                docId: newUserDoc.id,
            });
            req.loggedUser = newUser;

            // delete the verify email instance
            await emailVerificationCRUD.deleteDoc(email_verification_doc.id);

            return res.status(200).json({
                message: "successfully verified email",
                user: newUser.toMap(),
            });
        } else {
            // show error
            return res.status(400).json({ message: "code is invalid" });
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
    }
};
