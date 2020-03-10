const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const _ = require("lodash"); // for modifing the array contents

const { UserModel, UserfromFirestore } = require("../../models/user");
const {
    EmailVerificationFromFirestore
} = require("../../models/emailVerification");
const { ForgotPasswordFromFirestore } = require("../../models/forgotPassword");

const { sendEmailToVerifyEmail, sendForgotPasswordEmail } = require("./helper");
const {
    registerValidation,
    loginValidation,
    EmailIDValidation,
    verifyEmailValidation,
    verifyForgotPasswordValidation
} = require("./authValidations");

const userCRUD = require("../../services/firestore/userCRUD");
const emailVerificationCRUD = require("../../services/firestore/emailVerificationCRUD");
const forgotPasswordCRUD = require("../../services/firestore/forgotPasswordCRUD");

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
        user.setPassword(hashedPassword);

        // create new user
        const userDoc = await userCRUD.createUser(user.toMap());
        user.setId(userDoc.id);

        // Assign a json web token
        const tokenSecret = process.env.Token_Secret;
        const jToken = jwt.sign({ id: user.getId() }, tokenSecret, {
            expiresIn: "1d"
        });

        await sendEmailToVerifyEmail(user);

        return res.header("authorization", jToken).json(jToken);
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" });
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
        let user = await userCRUD.getUserViaUsername(req.body.username);

        user = user.data();
        // Check user password
        const validPassword = await bcrypt.compare(
            req.body.password,
            user.password
        );

        if (!validPassword)
            return res.status(400).json({ message: "Password is invalid" });

        if (process.env.NODE_ENV !== "development") {
            if (!user.user.email_verified) {
                return res
                    .status(401)
                    .json({ message: "Access denied as email isn't verified" });
            }
        }

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

        if (!userDoc) {
            return res.status(400).json({
                message: `No account exists associating with ${req.body.email}`
            });
        }

        // convert the userdoc to user modal
        let user = UserfromFirestore({
            mapData: userDoc.data(),
            id: userDoc.id
        });

        try {
            // send the mail
            await sendForgotPasswordEmail(user);

            return res.status(200).json({
                message: `reset password link is mailed to ${req.body.email}`
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

module.exports.getUser = async (req, res) => {
    return res.json({ user: req.loggedUser.toMap() });
};

module.exports.sendEmailVerification = async (req, res) => {
    try {
        await sendEmailToVerifyEmail(req.loggedUser);
        return res.status(200).json({
            message:
                "Email verification sent successfully check your mail for code"
        });
    } catch (error) {
        console.log(error);
        return res.status(400).json({ message: "Internal server error" });
    }
};

module.exports.verifyEmail = async (req, res) => {
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
            docId: email_verification_doc.id
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
                docId: newUserDoc.id
            });
            req.loggedUser = newUser;

            // delete the verify email instance
            await emailVerificationCRUD.deleteDoc(email_verification_doc.id);

            return res.status(200).json({
                message: "successfully verified email",
                user: newUser.toMap()
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

module.exports.verifyForgotPassword = async (req, res) => {
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
            docId: user_doc.id
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
            docId: forgot_password_doc.id
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

module.exports.resetPassword = async (req, res) => {
    // code to reset password here
};

module.exports.editUser = async (req, res) => {
    // code to edit user profile
};
