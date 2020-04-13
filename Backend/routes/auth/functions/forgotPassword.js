//@ts-check

const { UserfromFirestore } = require("../../../models/user");

const { sendForgotPasswordEmail } = require("../helper");
const { EmailIDValidation } = require("../authValidations");

const userCRUD = require("../../../services/firestore/userCRUD");

module.exports = async (req, res) => {
    // validate the input data
    const validateData = EmailIDValidation(req.body);
    if (validateData.error) {
        return res
            .status(400)
            .json({ message: validateData.error.details[0].message });
    }

    // check if the email is present in database
    try {
        // const userDoc = await UserModel.findOne({ email: req.body.email });
        const userDoc = await userCRUD.getUserViaEmail(req.body.email);

        if (!userDoc || !userDoc.exists) {
            return res.status(400).json({
                message: `No account exists associating with ${req.body.email}`,
            });
        }

        // convert the userdoc to user modal
        let user = UserfromFirestore({
            mapData: userDoc.data(),
            docId: userDoc.id,
        });

        try {
            // send the mail
            await sendForgotPasswordEmail(user);

            return res.status(200).json({
                message: `reset password link has been mailed to ${req.body.email}`,
            });
        } catch (error) {
            console.log(
                `Error when sending mail for reset password, error: ${error}`
            );
            return res.status(500).json({ message: "Internal server error" });
        }
    } catch (error) {
        console.log(
            `Error checking for email in database with error: ${error}`
        );
        return res.status(500).json({ message: "Internal server error" });
    }
};
