const express = require("express");

const {
    verifyToken,
    verifyUserWithToken,
    verifyUserWithoutEmailVerification,
} = require("./helper");

const {
    register,
    login,
    forgotPassword,
    getUser,
    sendEmailVerification,
    verifyEmail,
    verifyForgotPassword,
} = require("./functions");

// instance of new router
const router = express.Router();

// All ruotes to auth goes here
// route to register new user
router.post("/register", register);

// route to login new user
router.post("/login", login);

// route to forgotpassword
router.post("/forgotpassword", forgotPassword);

// route to get the logged user details
router.get("/user", verifyToken, verifyUserWithToken, getUser);

// route to send mail to verify the email of the user
router.post(
    "/sendEmailVerification",
    verifyToken,
    verifyUserWithoutEmailVerification,
    sendEmailVerification
);

// route to verify the secret code and verify the email of the user
router.post(
    "/verifyEmail",
    verifyToken,
    verifyUserWithoutEmailVerification,
    verifyEmail
);

// route to verify the given code and reset the password
router.post("./verifyForgotPassword", verifyForgotPassword);

module.exports = router;
