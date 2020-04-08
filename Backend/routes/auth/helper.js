const jwt = require("jsonwebtoken");

const { UserfromFirestore } = require("../../models/user");
const userFirestoreCRUD = require("../../services/firestore/userCRUD");
const {
    EmailVerificationModel,
    EmailVerificationFromFirestore
} = require("../../models/emailVerification");
const {
    ForgotPasswordModel,
    ForgotPasswordFromFirestore
} = require("../../models/forgotPassword");
const emailVerificationCRUD = require("../../services/firestore/emailVerificationCRUD");
const forgotPasswordCRUD = require("../../services/firestore/forgotPasswordCRUD");
const mailEmailVerification = require("../../services/mail/emailverfication");
const mailForgotPassword = require("../../services/mail/forgotPassword");

// verify the token for authentication
const verifyToken = (req, res, next) => {
    // Get auth header value
    const bearerHeader = req.headers["authorization"];

    // Check if bearer is undefined
    if (typeof bearerHeader !== "undefined") {
        // Split the header
        const bearer = bearerHeader.split(" ");
        // Get the token
        const bearerToken = bearer[1];
        // Set the token
        req.token = bearerToken;

        // run the next function
        next();
    } else {
        return res.status(401).json({ message: "Access Denied" });
    }
};

const verifyUserWithToken = async (req, res, next) => {
    // verifies the given token is correct and gets the user data
    jwt.verify(req.token, process.env.Token_Secret, async (err, authData) => {
        if (err) {
            console.log(`Error at verifying jwt token: ${err}`);
            return res.status(401).json({ message: err.message });
        } else {
            try {
                let loggedUser = await userFirestoreCRUD.getUserViaID(
                    authData.id
                );
                // if user doesn't exist
                if (!loggedUser) {
                    return res.status(400).json({
                        message: "No user exists with given id"
                    });
                }
                // when user exists
                else {
                    loggedUser = loggedUser.data();
                    loggedUser = UserfromFirestore({
                        mapData: loggedUser,
                        docId: loggedUser.id
                    });
                    req.loggedUser = loggedUser;

                    if (process.env.NODE_ENV === "development") {
                        // doesn't check email verification in development environment
                        next();
                    } else {
                        // checks email verification in production environment
                        if (loggedUser.getEmail_verified()) {
                            next();
                        } else {
                            return res.status(401).json({
                                message: "Access denied as email isn't verified"
                            });
                        }
                    }
                }
            } catch (error) {
                console.log(error);
                return res.status(500).json({ message: "Error finding user" });
            }
        }
    });
};

const verifyUserWithoutEmailVerification = async (req, res, next) => {
    // verifies the given token is correct and gets the user data
    jwt.verify(req.token, process.env.Token_Secret, async (err, authData) => {
        if (err) {
            console.log(`Error at verifying jwt token: ${err}`);
            return res.status(401).json({ message: err.message });
        } else {
            try {
                let loggedUser = await userFirestoreCRUD.getUserViaID(
                    authData.id
                );
                // if user doesn't exist
                if (!loggedUser) {
                    return res.status(400).json({
                        message: "No user exists with given id"
                    });
                }
                // when user exists
                else {
                    loggedUser = loggedUser.data();
                    loggedUser = UserfromFirestore({
                        mapData: loggedUser,
                        docId: loggedUser.id
                    });
                    req.loggedUser = loggedUser;

                    next();
                }
            } catch (error) {
                console.log(error);
                return res.status(500).json({ message: "Error finding user" });
            }
        }
    });
};

const sendEmailToVerifyEmail = async user => {
    // create a email verification code and send email
    let secret_code = Math.floor(Math.random() * 1000000);
    const email_verification = new EmailVerificationModel({
        id: user.getId(),
        email: user.getEmail(),
        secret_code: secret_code
    });

    // save to database
    await emailVerificationCRUD.createEmailVerification(
        email_verification.toMap()
    );
    mailEmailVerification(user.getEmail(), secret_code);
};

const sendForgotPasswordEmail = async user => {
    // create a email verification code and send email
    let secret_code = Math.floor(Math.random() * 1000000);
    const forgot_password = new ForgotPasswordModel({
        id: user.getId(),
        email: user.getEmail(),
        secret_code
    });

    // save to database
    await forgotPasswordCRUD.createForgotPassord(forgot_password.toMap());
    mailForgotPassword(user.getEmail(), secret_code);
};

// -----------------------------------------------------------------------
const getUserById = async user_id => {
    try {
        let user = await userFirestoreCRUD.getUserViaID(
            user_id
        );
        // if user doesn't exist
        if (!user) {
            return res.status(400).json({
                message: "No user exists with given id"
            });
        }
        // when user exists
        else {
            user = user.data();
            user = UserfromFirestore({
                mapData: user,
                docId: user.id
            });

            return user;
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Error finding user" });
    }
}

const getUserByUsername = async username => {
    try {
        let user = await userFirestoreCRUD.getUserViaUsername(
            username
        );
        // if user doesn't exist
        if (!user) {
            return res.status(400).json({
                message: "No user exists with given username"
            });
        }
        // when user exists
        else {
            user = user.data();
            user = UserfromFirestore({
                mapData: user,
                docId: user.id
            });
            
            return user;
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Error finding user" });
    }
}

module.exports = {
    verifyToken,
    verifyUserWithToken,
    sendEmailToVerifyEmail,
    verifyUserWithoutEmailVerification,
    sendForgotPasswordEmail,
    getUserById,
    getUserByUsername
};
